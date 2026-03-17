import 'package:dio/dio.dart';
import 'package:cripto_din/data/datasources/gemini/gemini_datasource.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';
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
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Timeout ao conectar com a IA.");

        case DioExceptionType.receiveTimeout:
          throw Exception("A IA demorou para responder.");

        case DioExceptionType.badResponse:
          throw Exception("Erro Gemini: ${e.response?.data}");

        default:
          throw Exception("Erro de rede: ${e.message}");
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
- Máximo 6 linhas
''';
  }
}
