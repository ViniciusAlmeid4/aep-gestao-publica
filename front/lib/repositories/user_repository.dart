import '../core/network/api_client.dart';
import '../models/post_user_request.dart';
import '../models/user_model.dart';

class UserRepository {
  final ApiClient apiClient;

  UserRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.get('/users');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(UserModel.fromJson)
          .toList();
    }
    return [];
  }

  Future<UserModel> getUser(String id) async {
    final response = await apiClient.get('/users/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserModel.fromJson(data);
    }
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<UserModel> createUser(PostUserRequest request) async {
    final response = await apiClient.post('/users', request.toJson());
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return UserModel.fromJson(data);
    }
    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> updateUser(String id, PostUserRequest request) async {
    await apiClient.patch('/users/$id', request.toJson());
  }
}
