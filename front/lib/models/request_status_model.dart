import 'user_response.dart';

class RequestStatusModel {
  final int id;
  final String status;
  final String requestId;
  final UserResponse? responsable;
  final String description;
  final DateTime createdAt;

  RequestStatusModel({
    required this.id,
    required this.status,
    required this.requestId,
    this.responsable,
    required this.description,
    required this.createdAt,
  });

  factory RequestStatusModel.fromJson(Map<String, dynamic> json) {
    return RequestStatusModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      requestId: json['requestId']?.toString() ?? '',
      responsable:
          json['responsable'] != null &&
              json['responsable'] is Map<String, dynamic>
          ? UserResponse.fromJson(json['responsable'] as Map<String, dynamic>)
          : null,
      description: json['description']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
