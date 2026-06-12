import '../core/network/api_client.dart';
import '../models/post_request_model.dart';
import '../models/post_request_status_model.dart';
import '../models/request_model.dart';
import '../models/request_status_model.dart';

class RequestRepository {
  final ApiClient apiClient;

  RequestRepository(this.apiClient);

  Future<List<RequestModel>> getRequests() async {
    final response = await apiClient.get('/requests');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(RequestModel.fromJson)
          .toList();
    }
    return [];
  }

  Future<RequestModel> createRequest(PostRequestModel requestModel) async {
    final response = await apiClient.post('/requests', requestModel.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data);
      return RequestModel.fromJson(body);
    }
    throw Exception('Erro ao criar solicitação');
  }

  Future<List<RequestStatusModel>> getRequestStatus(String requestId) async {
    final response = await apiClient.get('/requests/$requestId/status');
    final data = response.data;
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(RequestStatusModel.fromJson)
          .toList();
    }
    return [];
  }

  Future<RequestStatusModel> createRequestStatus(
    String requestId,
    PostRequestStatusModel model,
  ) async {
    final response = await apiClient.post(
      '/requests/$requestId/status',
      model.toJson(),
    );
    if (response.statusCode == 201 || response.statusCode == 200) {
      final body = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data);
      return RequestStatusModel.fromJson(body);
    }
    throw Exception('Erro ao adicionar status');
  }
}
