// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aep_front/app.dart';
import 'package:aep_front/core/network/api_client.dart';
import 'package:aep_front/core/storage/secure_storage_service.dart';
import 'package:aep_front/repositories/auth_repository.dart';
import 'package:aep_front/repositories/request_repository.dart';
import 'package:aep_front/repositories/user_repository.dart';
import 'package:aep_front/viewmodels/auth_viewmodel.dart';
import 'package:aep_front/viewmodels/requests_viewmodel.dart';

void main() {
  testWidgets('Login screen is displayed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<RequestRepository>(
            create: (_) => RequestRepository(ApiClient()),
          ),
          Provider<UserRepository>(create: (_) => UserRepository(ApiClient())),
          ChangeNotifierProvider<AuthViewModel>(
            create: (_) => AuthViewModel(
              AuthRepository(ApiClient()),
              SecureStorageService(),
            ),
          ),
          ChangeNotifierProvider<RequestsViewModel>(
            create: (context) =>
                RequestsViewModel(context.read<RequestRepository>()),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Portal Público'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });
}
