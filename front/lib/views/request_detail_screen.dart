import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/post_request_status_model.dart';
import '../models/request_model.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/request_details_viewmodel.dart';
import 'widgets/status_timeline.dart';

class RequestDetailScreen extends StatefulWidget {
  final String requestId;
  final RequestModel? request;

  const RequestDetailScreen({super.key, required this.requestId, this.request});

  @override
  State<RequestDetailScreen> createState() => _RequestDetailScreenState();
}

class _RequestDetailScreenState extends State<RequestDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RequestDetailsViewModel>().loadStatus(widget.requestId);
    });
  }

  Future<void> _showAddStatusDialog() async {
    final auth = context.read<AuthViewModel>();
    if (!auth.isAdmin) return;

    final detailsViewModel = context.read<RequestDetailsViewModel>();
    final formKey = GlobalKey<FormState>();
    String statusValue = 'OPEN';
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Adicionar novo andamento',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      initialValue: statusValue,
                      dropdownColor: const Color(0xFF111111),
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration('Status'),
                      items: const [
                        DropdownMenuItem(value: 'OPEN', child: Text('Aberta')),
                        DropdownMenuItem(
                          value: 'TRIAGE',
                          child: Text('Triagem'),
                        ),
                        DropdownMenuItem(
                          value: 'IN_PROGRESS',
                          child: Text('Em andamento'),
                        ),
                        DropdownMenuItem(
                          value: 'RESOLVED',
                          child: Text('Resolvida'),
                        ),
                        DropdownMenuItem(
                          value: 'CLOSED',
                          child: Text('Encerrada'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          statusValue = value;
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      cursorColor: Colors.white,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration('Descrição do status'),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Informe a descrição'
                          : null,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _OutlineActionButton(
                          label: 'Cancelar',
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        const SizedBox(width: 12),
                        _OutlineActionButton(
                          label: detailsViewModel.isSubmitting ? '' : 'Salvar',
                          onPressed: detailsViewModel.isSubmitting
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) return;
                                  final created = await detailsViewModel
                                      .addStatus(
                                        widget.requestId,
                                        PostRequestStatusModel(
                                          status: statusValue,
                                          description: descriptionController
                                              .text
                                              .trim(),
                                        ),
                                      );
                                  if (!mounted) return;
                                  Navigator.of(context).pop(created);
                                },
                          child: detailsViewModel.isSubmitting
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    descriptionController.dispose();

    if (result == true && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Andamento adicionado.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();
    final detailsViewModel = context.watch<RequestDetailsViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(onBackPressed: () => context.go('/requests')),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48, 28, 48, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Detalhes da Solicitação',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 14),
                    if (widget.request != null)
                      _RequestSummary(request: widget.request!)
                    else
                      _MissingRequestSummary(requestId: widget.requestId),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Text(
                          'Andamentos',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const Spacer(),
                        if (auth.isAdmin)
                          _OutlineActionButton(
                            label: 'Adicionar andamento',
                            width: 172,
                            onPressed: _showAddStatusDialog,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: detailsViewModel.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : detailsViewModel.error != null
                            ? Center(
                                child: Text(
                                  detailsViewModel.error!,
                                  style: const TextStyle(
                                    color: Color(0xFFFF8A80),
                                  ),
                                ),
                              )
                            : StatusTimeline(
                                statuses: detailsViewModel.statusHistory,
                              ),
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
  final VoidCallback onBackPressed;

  const _Header({required this.onBackPressed});

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
          _OutlineActionButton(label: 'Voltar', onPressed: onBackPressed),
        ],
      ),
    );
  }
}

class _RequestSummary extends StatelessWidget {
  final RequestModel request;

  const _RequestSummary({required this.request});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Wrap(
        spacing: 34,
        runSpacing: 16,
        children: [
          _InfoBlock(label: 'ID', value: request.id, width: 315),
          _InfoBlock(
            label: 'Categoria',
            value: _categoryLabel(request.category),
          ),
          _InfoBlock(
            label: 'Status',
            value: _statusLabel(request.lastStatus?.status ?? 'OPEN'),
          ),
          _InfoBlock(label: 'Criada', value: _formatDate(request.createdAt)),
          _InfoBlock(
            label: 'Anônima',
            value: request.isAnonymous ? 'Sim' : 'Não',
          ),
          _InfoBlock(
            label: 'Solicitante',
            value: request.requester?.name ?? '-',
          ),
          _InfoBlock(
            label: 'Endereço',
            value:
                '${request.address.street}, ${request.address.number} - ${request.address.city}/${request.address.state}',
            width: 420,
          ),
          _InfoBlock(label: 'CEP', value: request.address.zipCode),
          _InfoBlock(
            label: 'Descrição',
            value: request.description,
            width: 620,
          ),
        ],
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

class _MissingRequestSummary extends StatelessWidget {
  final String requestId;

  const _MissingRequestSummary({required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(18),
      ),
      child: _InfoBlock(label: 'ID', value: requestId, width: 315),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String label;
  final String value;
  final double width;

  const _InfoBlock({
    required this.label,
    required this.value,
    this.width = 220,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final double width;
  final Widget? child;

  const _OutlineActionButton({
    required this.label,
    required this.onPressed,
    this.width = 116,
    this.child,
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
          disabledForegroundColor: Colors.white70,
          side: const BorderSide(color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.zero,
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        child: child ?? Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

InputDecoration _fieldDecoration(String label) {
  const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderSide: BorderSide(color: Colors.white),
  );

  return InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    enabledBorder: border,
    focusedBorder: border,
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFFF8A80)),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFFF8A80)),
    ),
    errorStyle: const TextStyle(color: Color(0xFFFF8A80), fontSize: 11),
    filled: true,
    fillColor: const Color(0xFF111111),
  );
}
