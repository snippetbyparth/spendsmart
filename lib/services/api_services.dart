import 'package:dio/dio.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  // Auth
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    final response = await _dio.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  // Transactions
  Future<List> getTransactions(int userId) async {
    final response = await _dio.get('/transactions/', queryParameters: {'user_id': userId});
    return response.data;
  }

  Future<Map<String, dynamic>> createTransaction(int userId, Map<String, dynamic> transaction) async {
    final response = await _dio.post('/transactions/', 
      queryParameters: {'user_id': userId},
      data: transaction,
    );
    return response.data;
  }
}