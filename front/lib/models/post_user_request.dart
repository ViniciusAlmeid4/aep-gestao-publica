import 'address.dart';

class PostUserRequest {
  final String? id;
  final String name;
  final DateTime? birthDate;
  final Address address;
  final String email;
  final String password;
  final String role;

  PostUserRequest({
    this.id,
    required this.name,
    this.birthDate,
    required this.address,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'birthDate': birthDate == null ? null : _formatDate(birthDate!),
      'address': address.toJson(),
      'email': email,
      'password': password,
      'role': role,
    };
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }
}
