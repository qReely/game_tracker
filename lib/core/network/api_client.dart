import 'package:dio/dio.dart';
import 'package:game_tracker/core/env/env.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio) {
    _dio.options.baseUrl = 'https://api.rawg.io/api';
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Automatically add the API key to every request
          options.queryParameters.addAll({'key': Env.rawgApiKey});
          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }
}