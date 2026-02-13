import 'package:cripto_din/model/cripto_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoingeckoService {
    final Dio dio = Dio(
      BaseOptions(baseUrl: dotenv.env['COINGECKO_BASE_URL']!),
    ); //! significa que tenho certeza que não é nulo

    Future<List<CriptoModel>> listaDeCriptomoedas() async {
      try {
        final response = await dio.get(
          '/coins/markets',
          queryParameters: {
            'vs_currency': dotenv.env['COINGECKO_VS_CURRENCY']!,
            'order': dotenv.env['COINGECKO_ORDER']!,
            'per_page': dotenv.env['COINGECKO_PER_PAGE']!,
            'page': dotenv.env['COINGECKO_PAGE']!,
            'sparkline': dotenv.env['COINGECKO_SPARKLINE']!,
          },
        );
         return (response.data as List)
      .map((json) => CriptoModel.fromApiJson(json))
      .toList();
      } catch (e) {
        throw Exception('Erro ao buscar criptomoedas: $e');
      }
    }
  }

