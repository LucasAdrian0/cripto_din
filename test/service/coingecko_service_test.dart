import 'package:cripto_din/model/cripto_model.dart';
import 'package:cripto_din/service/coingecko_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: "local.env");
  });
  test('coingecko - listar criptomoedas ...', () async {
    final dio = DioMock();
    final response = Response(
      statusCode: 200,
      data: ,
      requestOptions: RequestOptions(path: '/'));
    when(() => dio.get(any())).thenAnswer((_) async => null);

    final repository = CoingeckoService();

    final listadecriptos = await repository.listaDeCriptomoedas();

    expect(listadecriptos, isA<List<CriptoModel>>());
  });
}

final jsonMock = [

  {
    "change24h":-2.05012,
    "id": "bitcoin",
    "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
    "name":"Bitcoin",
    "price": 329980,
    "symbol": "btc"
     }
];