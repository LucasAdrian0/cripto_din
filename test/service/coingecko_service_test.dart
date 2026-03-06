import 'package:cripto_din/data/model/cripto_model.dart';
import 'package:cripto_din/data/service/coingecko_service_impl.dart';
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
      data: jsonMock,
      requestOptions: RequestOptions(path: '/'),
    );
    when(() => dio.get(any())).thenAnswer((_) async => response);

    final repository = CoingeckoServiceImpl();

    final listadecriptos = await repository.listaDeCriptomoedas();

    expect(listadecriptos, isA<List<CriptoModel>>());
    expect(listadecriptos.length, 50);
  });
}

final jsonMock = [
  {
    "change24h": -2.05012,
    "id": "bitcoin",
    "image":
        "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
    "name": "Bitcoin",
    "price": 329980,
    "symbol": "btc",
  },
];
