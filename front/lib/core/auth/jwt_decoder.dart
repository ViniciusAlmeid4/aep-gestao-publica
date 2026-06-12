import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decodePayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return const {};
    }

    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final jsonMap = jsonDecode(decoded);
      if (jsonMap is Map<String, dynamic>) {
        return jsonMap;
      }
      return const {};
    } catch (_) {
      return const {};
    }
  }

  static String? getRole(String token) {
    final payload = decodePayload(token);
    if (payload['role'] != null) {
      return payload['role'].toString();
    }
    if (payload['roles'] != null) {
      if (payload['roles'] is List && payload['roles'].isNotEmpty) {
        return payload['roles'].first.toString();
      }
      return payload['roles'].toString();
    }
    return null;
  }
}
