import 'package:flutter/foundation.dart';

import '../models/post_user_request.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UsersViewModel extends ChangeNotifier {
  final UserRepository _repository;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  List<UserModel> _users = [];

  UsersViewModel(this._repository);

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  List<UserModel> get users => List.unmodifiable(_users);

  Future<void> fetchUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _repository.getUsers();
    } catch (exception) {
      _error = exception.toString();
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> getUser(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      return await _repository.getUser(id);
    } catch (exception) {
      _error = exception.toString();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createUser(PostUserRequest request) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _repository.createUser(request);
      _users.insert(0, created);
      return true;
    } catch (exception) {
      _error = exception.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> updateUser(String id, PostUserRequest request) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.updateUser(id, request);
      return true;
    } catch (exception) {
      _error = exception.toString();
      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
