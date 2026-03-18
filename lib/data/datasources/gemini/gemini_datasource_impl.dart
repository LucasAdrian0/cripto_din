import 'package:dio/dio.dart';
import 'package:cripto_din/data/datasources/gemini/gemini_datasource.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiDatasourceImpl implements GeminiDatasource {
  final Dio dio;

  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
  final String model = dotenv.env['GEMINI_MODEL'] ?? '';
  final String baseUrl = dotenv.env['GEMINI_BASE_URL'] ?? '';

  GeminiDatasourceImpl({Dio? dioClient}) : dio = dioClient ?? Dio() {
    dio.options = BaseOptions(
      headers: {'Content-Type': 'application/json'},
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 40),
    );
  }

  // ==========================================================
  // PERGUNTAR IA
  // ==========================================================
  @override
  Future<String> perguntarIA({
    required String pergunta,
    required List<Cripto> criptos,
    required List<NoticiaChat> noticias,
  }) async {
    final prompt = _buildPrompt(pergunta, criptos, noticias);

    // validação obrigatória (evita erro silencioso)
    if (apiKey.isEmpty) {
      throw Exception("API KEY não configurada no .env");
    }

    if (model.isEmpty) {
      throw Exception("MODEL não configurado no .env");
    }

    // logs de debug (ESSENCIAL)
    debugPrint("MODEL: $model");
    debugPrint("URL FINAL: $baseUrl/models/$model:generateContent");
    debugPrint("API KEY: ${apiKey.isNotEmpty ? "OK" : "VAZIA"}");

    try {
      final response = await dio.post(
        "$baseUrl/models/$model:generateContent",
        queryParameters: {"key": apiKey},
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
          "generationConfig": {"temperature": 0.7, "maxOutputTokens": 800},
        },
      );

      // =========================
      // STATUS CHECK
      // =========================
      if (response.statusCode != 200) {
        throw Exception(
          "Gemini retornou status inválido: ${response.statusCode}",
        );
      }

      return _extractText(response.data);
    }
    // =========================
    // ERROS DIO V5
    // =========================
    on DioException catch (e) {
      debugPrint("========== ERRO DIO ==========");
      debugPrint("TYPE: ${e.type}");
      debugPrint("MESSAGE: ${e.message}");
      debugPrint("RESPONSE: ${e.response?.data}");
      debugPrint("REQUEST: ${e.requestOptions.uri}");
      debugPrint("==============================");
      debugPrint(
        "Erro Dio Gemini: ${e.message}\nResponse: ${e.response?.data}",
      );
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Timeout ao conectar com a IA.");

        case DioExceptionType.receiveTimeout:
          throw Exception("A IA demorou para responder.");

        case DioExceptionType.badResponse:
          if (e.response?.statusCode == 429) {
            throw Exception(
              "Limite de uso da IA atingido. Tente novamente mais tarde.",
            );
          }
          throw Exception("Erro Gemini: ${e.response?.data}");

        default:
          throw Exception("Erro de rede detalhado : ${e.message}");
      }
    } catch (e) {
      throw Exception("Erro inesperado GeminiDatasource: $e");
    }
  }

  // ==========================================================
  // EXTRAI TEXTO DA RESPOSTA GEMINI (SAFE PARSE)
  // ==========================================================
  String _extractText(dynamic data) {
    final text = data?["candidates"]?[0]?["content"]?["parts"]?[0]?["text"];

    if (text == null || text.toString().trim().isEmpty) {
      throw Exception(
        "Gemini retornou resposta vazia.\nResposta completa: $data",
      );
    }

    return text.toString();
  }

  // ==========================================================
  // PROMPT BUILDER
  // ==========================================================
  String _buildPrompt(
    String pergunta,
    List<Cripto> criptos,
    List<NoticiaChat> noticias,
  ) {
    final noticiasTexto = noticias.map((n) => "- ${n.titulo}").join("\n");

    final criptosTexto = criptos.isEmpty
        ? "Nenhuma cripto encontrada."
        : criptos.map((c) => "- ${c.name} (${c.symbol})").join("\n");

    return '''
Você é um especialista em criptomoedas e mercado financeiro.

=== CRIPTOMOEDAS DO USUÁRIO ===
$criptosTexto

=== NOTÍCIAS RECENTES ===
$noticiasTexto

=== PERGUNTA DO USUÁRIO ===
$pergunta

Responda:
- Em português
- De forma clara
- Direta
- Com base nas notícias e criptos fornecidas
- Evite respostas genéricas
- Se não souber a resposta, diga que não sabe ao invés de inventar algo.
- Seja breve
- Fale separado o sentimento do mercado (otimista, pessimista, neutro) baseado nas notícias
- Máximo 6 linhas
''';
  }
}
