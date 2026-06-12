import 'address.dart';
import 'request_status_model.dart';
import 'user_response.dart';

class RequestModel {
  final String id;
  final String category;
  final String description;
  final String linkedFile;
  final Address address;
  final bool isAnonymous;
  final DateTime createdAt;
  final UserResponse? requester;
  final RequestStatusModel? lastStatus;

  RequestModel({
    required this.id,
    required this.category,
    required this.description,
    required this.linkedFile,
    required this.address,
    required this.isAnonymous,
    required this.createdAt,
    this.requester,
    this.lastStatus,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      linkedFile: json['linkedFile']?.toString() ?? '',
      address:
          json['address'] != null && json['address'] is Map<String, dynamic>
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : Address(street: '', number: '', city: '', state: '', zipCode: ''),
      isAnonymous: json['isAnonymous'] == true,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      requester:
          json['requester'] != null && json['requester'] is Map<String, dynamic>
          ? UserResponse.fromJson(json['requester'] as Map<String, dynamic>)
          : null,
      lastStatus:
          json['lastStatus'] != null &&
              json['lastStatus'] is Map<String, dynamic>
          ? RequestStatusModel.fromJson(
              json['lastStatus'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}
