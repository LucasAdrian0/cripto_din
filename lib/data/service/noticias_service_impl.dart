import 'package:cripto_din/data/mapper/noticias_mapper.dart';
import 'package:cripto_din/data/model/noticias_model.dart';
import 'package:cripto_din/domain/services/noticias_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NoticiasServiceImpl implements NoticiasService {
  final Dio dio = Dio(BaseOptions(baseUrl: dotenv.env['THENEWSAPI_BASE_URL']!));

  @override
  Future<List<NoticiasModel>> carrocelDeNoticias() async {
    try {
      debugPrint("Buscando notícias da API...");
      final response = await dio.get(
        '',
        queryParameters: {
          'api_token': dotenv.env['THENEWSAPI_APITOKEN']!,
          'language': dotenv.env['THENEWSAPI_LANGUAGE']!,
          'limit': dotenv.env['THENEWSAPI_LIMIT']!,
          'search': dotenv.env['THENEWSAPI_SEARCH']!,
        },
      );

      final data = response.data['data'] as List;

      return data.map((json) => NoticiasMapper.fromApiJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar notícias: $e');
    }
  }
}
