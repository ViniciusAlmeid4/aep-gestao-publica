import 'address.dart';

class UserResponse {
  final String id;
  final String name;
  final String email;
  final String role;
  final Address? address;

  UserResponse({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.address,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      address:
          json['address'] != null && json['address'] is Map<String, dynamic>
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
    );
  }
}
