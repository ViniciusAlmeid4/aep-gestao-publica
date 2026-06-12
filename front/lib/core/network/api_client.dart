import 'dart:convert';

import 'package:dio/dio.dart';

import '../constants.dart';
import 'api_exception.dart';
import '../storage/secure_storage_service.dart';

class ApiClient {
  final Dio dio;
  final SecureStorageService _storage;

  ApiClient({Dio? externalDio, SecureStorageService? storage})
    : dio =
          externalDio ??
          Dio(
            BaseOptions(
              baseUrl: AppConstants.apiBaseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          ),
      _storage = storage ?? SecureStorageService() {
    final interceptors = dio.interceptors;
    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            return handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                error: 'Unauthorized',
                type: error.type,
                response: error.response,
              ),
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(String path) async {
    try {
      final response = await dio.get(path);
      return response;
    } on DioException catch (exception) {
      throw _handleError(exception);
    }
  }

  Future<Response> post(String path, Map<String, dynamic> body) async {
    try {
      final response = await dio.post(path, data: jsonEncode(body));
      return response;
    } on DioException catch (exception) {
      throw _handleError(exception);
    }
  }

  Future<Response> patch(String path, Map<String, dynamic> body) async {
    try {
      final response = await dio.patch(path, data: jsonEncode(body));
      return response;
    } on DioException catch (exception) {
      throw _handleError(exception);
    }
  }

  ApiException _handleError(DioException exception) {
    if (exception.response != null) {
      final status = exception.response?.statusCode;
      final serverMessage = exception.response?.data.toString();
      return ApiException(serverMessage ?? 'Erro inesperado', status);
    }

    if (exception.error is String && exception.error == 'Unauthorized') {
      return ApiException('Token inválido ou expirado', 401);
    }

    if (exception.type == DioExceptionType.connectionTimeout ||
        exception.type == DioExceptionType.receiveTimeout) {
      return ApiException('Tempo de conexão esgotado. Verifique sua rede.');
    }

    return ApiException('Falha de conexão. Verifique sua rede.');
  }
}
