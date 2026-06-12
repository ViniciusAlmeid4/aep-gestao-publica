import 'package:flutter/foundation.dart';

import '../core/auth/jwt_decoder.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/login_request.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;
  final SecureStorageService _storage;

  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _errorMessage;
  String? _role;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;
  String? get role => _role;

  AuthViewModel(this._repository, this._storage) {
    _loadPersistedToken();
  }

  Future<void> _loadPersistedToken() async {
    _isLoading = true;
    notifyListeners();

    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      _role = JwtDecoder.getRole(token);
      _isAuthenticated = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );
      await _storage.saveToken(response.token);
      _role = JwtDecoder.getRole(response.token);
      _isAuthenticated = true;
    } catch (exception) {
      _errorMessage = exception.toString();
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _storage.deleteToken();
    _isAuthenticated = false;
    _role = null;
    notifyListeners();
  }

  bool get isAdmin {
    final roleValue = _role?.toLowerCase() ?? '';
    return roleValue.contains('funcionario') ||
        roleValue.contains('admin') ||
        roleValue.contains('prefeitura');
  }
}
