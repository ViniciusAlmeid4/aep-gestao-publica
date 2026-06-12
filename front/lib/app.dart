import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'models/request_model.dart';
import 'models/user_model.dart';
import 'repositories/request_repository.dart';
import 'repositories/user_repository.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/request_details_viewmodel.dart';
import 'viewmodels/users_viewmodel.dart';
import 'views/login_screen.dart';
import 'views/request_detail_screen.dart';
import 'views/request_list_screen.dart';
import 'views/user_form_screen.dart';
import 'views/user_management_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    final requestRepository = context.read<RequestRepository>();
    final userRepository = context.read<UserRepository>();

    final router = GoRouter(
      initialLocation: '/login',
      refreshListenable: authViewModel,
      redirect: (context, state) {
        final isLogged = authViewModel.isAuthenticated;
        final loggingIn = state.uri.toString() == '/login';
        final managingUsers = state.uri.path.startsWith('/users');

        if (!isLogged && !loggingIn) {
          return '/login';
        }
        if (isLogged && loggingIn) {
          return '/requests';
        }
        if (isLogged && managingUsers && !authViewModel.isAdmin) {
          return '/requests';
        }
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/requests',
          builder: (context, state) => const RequestListScreen(),
        ),
        GoRoute(
          path: '/requests/:id',
          builder: (context, state) {
            final requestId = state.pathParameters['id']!;
            final request = state.extra is RequestModel
                ? state.extra as RequestModel
                : null;
            return ChangeNotifierProvider(
              create: (_) => RequestDetailsViewModel(requestRepository),
              child: RequestDetailScreen(
                requestId: requestId,
                request: request,
              ),
            );
          },
        ),
        GoRoute(
          path: '/users',
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (_) => UsersViewModel(userRepository),
              child: const UserManagementScreen(),
            );
          },
        ),
        GoRoute(
          path: '/users/new',
          builder: (context, state) {
            return ChangeNotifierProvider(
              create: (_) => UsersViewModel(userRepository),
              child: const UserFormScreen(),
            );
          },
        ),
        GoRoute(
          path: '/users/:id',
          builder: (context, state) {
            final userId = state.pathParameters['id']!;
            final user = state.extra is UserModel
                ? state.extra as UserModel
                : null;
            return ChangeNotifierProvider(
              create: (_) => UsersViewModel(userRepository),
              child: UserFormScreen(userId: userId, initialUser: user),
            );
          },
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Prefeitura - Solicitações',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
