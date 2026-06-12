import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/request_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/requests_viewmodel.dart';
import 'create_request_dialog.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestsViewModel>().fetchRequests();
    });
  }

  Future<void> _showCreateRequestDialog() async {
    final viewModel = context.read<RequestsViewModel>();
    final created = await showDialog<bool>(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: viewModel,
        child: const CreateRequestDialog(),
      ),
    );

    if (created == true) {
      await viewModel.fetchRequests();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final viewModel = context.watch<RequestsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(
              isAdmin: auth.isAdmin,
              onRequestsPressed: () => context.go('/requests'),
              onUsersPressed: () => context.go('/users'),
              onLogoutPressed: auth.logout,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 38, 48, 56),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Minhas Solicitações',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        _OutlineButton(label: 'Abertas', onPressed: () {}),
                        const SizedBox(width: 38),
                        _OutlineButton(label: 'Finalizadas', onPressed: () {}),
                        const SizedBox(width: 38),
                        _OutlineButton(label: 'Em Andamento', onPressed: () {}),
                        const Spacer(),
                        _OutlineButton(
                          label: 'Nova Solicitação',
                          onPressed: _showCreateRequestDialog,
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Expanded(
                      child: _RequestsTable(
                        isLoading: viewModel.isLoading,
                        error: viewModel.error,
                        requests: viewModel.requests,
                        onRefresh: viewModel.fetchRequests,
                        onRequestTap: (request) {
                          context.push(
                            '/requests/${request.id}',
                            extra: request,
                          );
                        },
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
  final bool isAdmin;
  final VoidCallback onRequestsPressed;
  final VoidCallback onUsersPressed;
  final VoidCallback onLogoutPressed;

  const _Header({
    required this.isAdmin,
    required this.onRequestsPressed,
    required this.onUsersPressed,
    required this.onLogoutPressed,
  });

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
          _OutlineButton(
            label: 'Minhas Solicitações',
            width: 132,
            onPressed: onRequestsPressed,
          ),
          const SizedBox(width: 10),
          if (isAdmin) ...[
            _OutlineButton(
              label: 'Meus Dados',
              width: 130,
              onPressed: onUsersPressed,
            ),
            const SizedBox(width: 10),
          ],
          _OutlineButton(label: 'Sair', width: 82, onPressed: onLogoutPressed),
        ],
      ),
    );
  }
}

class _RequestsTable extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<RequestModel> requests;
  final Future<void> Function() onRefresh;
  final ValueChanged<RequestModel> onRequestTap;

  const _RequestsTable({
    required this.isLoading,
    required this.error,
    required this.requests,
    required this.onRefresh,
    required this.onRequestTap,
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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(22),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tableWidth = constraints.maxWidth < 934
              ? 934.0
              : constraints.maxWidth;

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 318),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _TableHeader(),
                        const Divider(height: 1, color: Colors.white70),
                        if (requests.isEmpty)
                          const SizedBox(
                            height: 260,
                            child: Center(
                              child: Text(
                                'Nenhuma solicitação encontrada.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        else
                          ...requests.map(
                            (request) => _RequestRow(
                              request: request,
                              onTap: () => onRequestTap(request),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 44,
      child: Row(
        children: [
          _Cell(width: 284, child: Text('ID')),
          _Cell(width: 170, child: Text('Categoria')),
          _Cell(width: 206, child: Text('Descrição')),
          _Cell(width: 130, child: Text('Criada')),
          _Cell(width: 124, child: Text('Status')),
        ],
      ),
    );
  }
}

class _RequestRow extends StatelessWidget {
  final RequestModel request;
  final VoidCallback onTap;

  const _RequestRow({required this.request, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.white70)),
        ),
        child: Row(
          children: [
            _Cell(width: 284, child: Text(request.id)),
            _Cell(width: 170, child: Text(_categoryLabel(request.category))),
            _Cell(
              width: 206,
              child: Text(
                request.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _Cell(width: 130, child: Text(_formatDate(request.createdAt))),
            _Cell(
              width: 124,
              child: _StatusBadge(status: request.lastStatus?.status ?? 'OPEN'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _categoryLabel(String category) {
    const labels = {
      'INFRASTRUCTURE': 'Infraestrutura',
      'SANITATION': 'Saneamento',
      'PUBLIC_LIGHTING': 'Iluminação Pública',
      'URBAN_CLEANING': 'Limpeza Urbana',
      'HEALTHCARE': 'Saúde',
      'EDUCATION': 'Educação',
      'PUBLIC_SAFETY': 'Segurança Pública',
      'ENVIRONMENT': 'Meio Ambiente',
      'ANIMAL_WELFARE': 'Bem-estar Animal',
      'OTHERS': 'Outros',
    };
    return labels[category] ?? category;
  }
}

class _Cell extends StatelessWidget {
  final double width;
  final Widget child;

  const _Cell({required this.width, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white, fontSize: 12),
          overflow: TextOverflow.ellipsis,
          child: child,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 29,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          disabledForegroundColor: Colors.white,
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        child: Text(_statusLabel(status)),
      ),
    );
  }

  String _statusLabel(String status) {
    const labels = {
      'OPEN': 'Aberta',
      'TRIAGE': 'Triagem',
      'IN_PROGRESS': 'Em andamento',
      'RESOLVED': 'Resolvida',
      'CLOSED': 'Encerrada',
    };
    return labels[status] ?? status;
  }
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double width;

  const _OutlineButton({
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
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}
