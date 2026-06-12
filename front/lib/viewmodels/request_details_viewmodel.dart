import 'package:flutter/foundation.dart';

import '../models/post_request_status_model.dart';
import '../models/request_status_model.dart';
import '../repositories/request_repository.dart';

class RequestDetailsViewModel extends ChangeNotifier {
  final RequestRepository _repository;

  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _error;
  List<RequestStatusModel> _statusHistory = [];

  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  String? get error => _error;
  List<RequestStatusModel> get statusHistory =>
      List.unmodifiable(_statusHistory);

  RequestDetailsViewModel(this._repository);

  Future<void> loadStatus(String requestId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _statusHistory = await _repository.getRequestStatus(requestId);
    } catch (exception) {
      _error = exception.toString();
      _statusHistory = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addStatus(String requestId, PostRequestStatusModel model) async {
    _isSubmitting = true;
    _error = null;
    notifyListeners();

    try {
      final status = await _repository.createRequestStatus(requestId, model);
      _statusHistory.insert(0, status);
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
