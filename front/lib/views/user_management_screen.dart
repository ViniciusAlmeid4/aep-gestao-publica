import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../viewmodels/users_viewmodel.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UsersViewModel>().fetchUsers();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserModel> _filteredUsers(List<UserModel> users) {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return users;
    return users.where((user) {
      return user.id.toLowerCase().contains(query) ||
          user.name.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query) ||
          (user.address?.zipCode.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UsersViewModel>();
    final users = _filteredUsers(viewModel.users);

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onRequestsPressed: () => context.go('/requests')),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 16, 22, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: 22,
                      runSpacing: 14,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const SizedBox(
                          width: 166,
                          child: Text(
                            'Gestão de Usuários',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 575,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (_) => setState(() {}),
                            cursorColor: Colors.white,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            decoration: _darkInputDecoration(
                              'Pesquisar usuários...',
                              icon: Icons.search,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        _OutlineActionButton(label: 'Ativos', onPressed: () {}),
                        const SizedBox(width: 24),
                        _OutlineActionButton(
                          label: 'Inativos',
                          onPressed: () {},
                        ),
                        const SizedBox(width: 24),
                        _OutlineActionButton(label: 'Novos', onPressed: () {}),
                        const Spacer(),
                        _OutlineActionButton(
                          label: 'Criar Cidadão',
                          onPressed: () => context.push('/users/new'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: _UsersTable(
                        isLoading: viewModel.isLoading,
                        error: viewModel.error,
                        users: users,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final VoidCallback onRequestsPressed;

  const _Header({required this.onRequestsPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white70)),
      ),
      child: Row(
        children: [
          const Text(
            'Portal público',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const Spacer(),
          _OutlineActionButton(
            label: 'Solicitações',
            onPressed: onRequestsPressed,
          ),
        ],
      ),
    );
  }
}

class _UsersTable extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<UserModel> users;

  const _UsersTable({
    required this.isLoading,
    required this.error,
    required this.users,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (error != null) {
      return Center(
        child: Text(error!, style: const TextStyle(color: Color(0xFFFF8A80))),
      );
    }
    if (users.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum usuário encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(const Color(0xFF111111)),
            dataRowColor: WidgetStateProperty.all(const Color(0xFF111111)),
            dividerThickness: 1,
            columnSpacing: 52,
            headingTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            dataTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
            columns: const [
              DataColumn(label: SizedBox(width: 260, child: Text('ID'))),
              DataColumn(label: SizedBox(width: 150, child: Text('Nome'))),
              DataColumn(label: SizedBox(width: 100, child: Text('CEP'))),
              DataColumn(label: SizedBox(width: 110, child: Text('Criada'))),
              DataColumn(label: SizedBox(width: 96, child: Text(''))),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user.id)),
                  DataCell(Text(user.name)),
                  DataCell(Text(user.address?.zipCode ?? '-')),
                  DataCell(Text(_formatDate(user.createdAt))),
                  DataCell(
                    _OutlineActionButton(
                      label: 'Editar',
                      width: 90,
                      onPressed: () =>
                          context.push('/users/${user.id}', extra: user),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double width;

  const _OutlineActionButton({
    required this.label,
    required this.onPressed,
    this.width = 116,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 31,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white54,
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

InputDecoration _darkInputDecoration(String hintText, {IconData? icon}) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: Colors.white),
  );

  return InputDecoration(
    hintText: hintText,
    prefixIcon: icon == null ? null : Icon(icon, color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white54),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    enabledBorder: border,
    focusedBorder: border,
    filled: true,
    fillColor: const Color(0xFF111111),
  );
}
