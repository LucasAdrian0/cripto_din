import 'package:cripto_din/domain/ia/gemini_promp_input.dart';

class GeminiPrompt {
  static String build(GeminiPromptInput input) {
    return '''
Você é um especialista em criptomoedas.

Notícias recentes:
${input.noticiasTexto}

Pergunta:
${input.pergunta}

Responda em português de forma objetiva.
''';
  }
}