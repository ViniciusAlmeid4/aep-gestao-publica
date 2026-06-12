import 'package:flutter/foundation.dart';

import '../models/post_request_model.dart';
import '../models/request_model.dart';
import '../repositories/request_repository.dart';

class RequestsViewModel extends ChangeNotifier {
  final RequestRepository _repository;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  List<RequestModel> _requests = [];

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  List<RequestModel> get requests => List.unmodifiable(_requests);

  RequestsViewModel(this._repository);

  Future<void> fetchRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _requests = await _repository.getRequests();
    } catch (exception) {
      _error = exception.toString();
      _requests = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createRequest(PostRequestModel model) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final created = await _repository.createRequest(model);
      _requests.insert(0, created);
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
