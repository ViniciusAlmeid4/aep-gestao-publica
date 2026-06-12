import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/network/api_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'repositories/auth_repository.dart';
import 'repositories/request_repository.dart';
import 'repositories/user_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/requests_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final apiClient = ApiClient();
  final secureStorage = SecureStorageService();

  runApp(
    MultiProvider(
      providers: [
        Provider<RequestRepository>(
          create: (_) => RequestRepository(apiClient),
        ),
        Provider<UserRepository>(create: (_) => UserRepository(apiClient)),
        ChangeNotifierProvider<AuthViewModel>(
          create: (_) =>
              AuthViewModel(AuthRepository(apiClient), secureStorage),
        ),
        ChangeNotifierProvider<RequestsViewModel>(
          create: (context) =>
              RequestsViewModel(context.read<RequestRepository>()),
        ),
      ],
      child: const App(),
    ),
  );
}
