import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:game_tracker/core/env/env.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://api.rawg.io/api')) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.queryParameters.addAll({'key': Env.rawgApiKey});
        return handler.next(options);
      },
      onError: (error, handler) {
        debugPrint(error.response?.data.toString());
      },
    ));
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }
}