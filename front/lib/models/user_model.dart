import 'address.dart';

class UserModel {
  final String id;
  final String name;
  final DateTime? birthDate;
  final Address? address;
  final String email;
  final String role;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    this.birthDate,
    this.address,
    required this.email,
    required this.role,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      birthDate: DateTime.tryParse(json['birthDate']?.toString() ?? ''),
      address:
          json['address'] != null && json['address'] is Map<String, dynamic>
          ? Address.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
    );
  }
}
