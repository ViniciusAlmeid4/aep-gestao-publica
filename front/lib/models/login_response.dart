class LoginResponse {
  final String token;

  LoginResponse({required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final tokenValue = json['Token'] ?? json['token'] ?? '';
    return LoginResponse(token: tokenValue.toString());
  }
}
