import 'package:cripto_din/model/carteira_criptomoedas_binance_model.dart';
import 'package:dio/dio.dart';

class CarteiraBinanceRepository
 {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.binance.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<CarteiraCriptomoedasBinanceModel> buscarCarteira({
    required String apiKey,
    required String secretKey,
    required int timestamp,
    required String signature,
  }) async {
    final response = await _dio.get(
      '/api/v3/account',
      queryParameters: {
        'timestamp': timestamp,
        'signature': signature,
      },
      options: Options(
        headers: {
          'X-MBX-APIKEY': apiKey,
        },
      ),
    );

    return CarteiraCriptomoedasBinanceModel.fromJson(response.data);
  }
}
