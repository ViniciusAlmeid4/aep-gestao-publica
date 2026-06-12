import '../core/network/api_client.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class AuthRepository {
  final ApiClient apiClient;

  AuthRepository(this.apiClient);

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await apiClient.post('/auth/login', request.toJson());
    if (response.statusCode == 200) {
      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data);
      return LoginResponse.fromJson(body);
    }
    throw Exception('Falha ao autenticar. Código: ${response.statusCode}');
  }
}
