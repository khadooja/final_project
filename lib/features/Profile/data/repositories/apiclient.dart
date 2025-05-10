import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient({required this.dio});

  Future<Response> get(String url) async {
    try {
      return await dio.get(url);
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future<Response> post(String url, {dynamic data}) async {
    try {
      return await dio.post(url, data: data);
    } catch (e) {
      throw Exception('Failed to post data');
    }
  }
}
