import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get geminiModel => dotenv.env['GEMINI_MODEL'] ?? '';
  static String get geminiBaseUrl => dotenv.env['GEMINI_BASE_URL'] ?? '';
}