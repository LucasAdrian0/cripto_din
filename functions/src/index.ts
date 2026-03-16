
import {setGlobalOptions} from "firebase-functions/v2";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import axios from "axios";
import * as dotenv from "dotenv";

dotenv.config();

setGlobalOptions({maxInstances: 3});

admin.initializeApp();
const db = admin.firestore();

interface Noticia {
  uuid: string;
  title: string;
  description: string;
  image_url: string;
  url: string;
  published_at: string;
  source: string;
}

export const buscarNoticias = onSchedule(
  {
    schedule: "every 30 minutes",
    timeZone: "America/Sao_Paulo",
  },
  async () => {
    try {
      console.log("Buscando notícias...");

      const BASE_URL = process.env.THENEWSAPI_BASE_URL;
      const API_TOKEN = process.env.THENEWSAPI_APITOKEN;
      const LANGUAGE = process.env.THENEWSAPI_LANGUAGE || "pt";
      const LIMIT = process.env.THENEWSAPI_LIMIT || "10";
      const SEARCH = process.env.THENEWSAPI_SEARCH || "crypto";

      if (!BASE_URL || !API_TOKEN) {
        throw new Error("Variáveis de ambiente não carregadas");
      }

      // pegar apenas notícias recentes (últimas 6 horas)
      const sixHoursAgo = new Date(
        Date.now() - 6 * 60 * 60 * 1000
      ).toISOString();

      const apiResponse = await axios.get(BASE_URL, {
        params: {
          api_token: API_TOKEN,
          language: LANGUAGE,
          limit: LIMIT,
          search: SEARCH,
          order_by: "added_desc",
          published_after: sixHoursAgo,
        },
      });

      const noticias: Noticia[] = apiResponse.data.data;

      if (!noticias || noticias.length === 0) {
        console.log("Nenhuma notícia retornada pela API");
        return;
      }

      const collectionName = "noticiasAtualAutom";

      // verificar quais UUID já existem
      const uuids = noticias.map((n) => n.uuid);

      const snapshot = await db
        .collection(collectionName)
        .where(admin.firestore.FieldPath.documentId(), "in", uuids)
        .get();

      const existentes = new Set(snapshot.docs.map((doc) => doc.id));

      const batch = db.batch();
      let novasNoticias = 0;

      for (const noticia of noticias) {
        const texto =
          (noticia.title + " " + noticia.description).toLowerCase();

        if (
          !texto.includes("crypto") &&
          !texto.includes("bitcoin") &&
          !texto.includes("ethereum") &&
          !texto.includes("blockchain")
        ) continue;

        if (existentes.has(noticia.uuid)) continue;

        const ref = db.collection(collectionName).doc(noticia.uuid);

        batch.set(ref, {
          title: noticia.title,
          description: noticia.description,
          imageUrl: noticia.image_url,
          url: noticia.url,
          publishedAt: noticia.published_at,
          source: noticia.source,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });

        novasNoticias++;
      }

      if (novasNoticias > 0) {
        await batch.commit();
        console.log(`${novasNoticias} notícias novas salvas`);
      } else {
        console.log("Nenhuma notícia nova encontrada");
      }
    } catch (error) {
      console.error("Erro ao buscar notícias:", error);
    }
  }
);
