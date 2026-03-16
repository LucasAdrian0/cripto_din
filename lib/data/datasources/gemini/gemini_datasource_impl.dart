import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:cripto_din/core/config/env.dart';
import 'package:cripto_din/data/datasources/gemini/gemini_datasource.dart';
import 'package:cripto_din/domain/entities/cripto.dart';
import 'package:cripto_din/domain/entities/noticia_chat.dart';

class GeminiDatasourceImpl implements GeminiDatasource {
  final Dio dio;
  final String apiKey = Env.geminiApiKey;
  final String model = Env.geminiModel;
  final String baseUrl = Env.geminiBaseUrl;

  GeminiDatasourceImpl({Dio? dioClient})
      : dio = dioClient ?? Dio() {
    dio.options.headers['Content-Type'] = 'application/json';
  }

  @override
  Future<String> perguntarIA({
    required String pergunta,
    required List<Cripto> criptos,
    required List<NoticiaChat> noticias,
  }) async {
    final prompt = _buildPrompt(pergunta, criptos, noticias);

    try {
      final response = await dio.post(
        "$baseUrl/models/$model:generateContent?key=$apiKey",
        data: {
          "contents": [
            {
              "parts": [
                {"text": prompt},
              ],
            },
          ],
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Erro na Gemini API: ${response.data}");
      }

      final data = response.data;
      return data["candidates"][0]["content"]["parts"][0]["text"] as String;
    } on DioError catch (e) {
      // Captura erros de rede, timeout ou resposta inválida
      throw Exception("Erro ao consultar Gemini API: ${e.response?.data ?? e.message}");
    } catch (e) {
      throw Exception("Erro inesperado ao chamar Gemini API: $e");
    }
  }

  String _buildPrompt(
    String pergunta,
    List<Cripto> criptos,
    List<NoticiaChat> noticias,
  ) {
    return '''
Você é um especialista em criptomoedas.

Notícias recentes:
${noticias.map((n) => n.titulo).join("\n")}

Pergunta:
$pergunta

Responda em português de forma objetiva.
''';
  }
}