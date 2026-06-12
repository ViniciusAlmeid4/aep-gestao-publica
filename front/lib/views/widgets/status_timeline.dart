import 'package:flutter/material.dart';

import '../../models/request_status_model.dart';

class StatusTimeline extends StatelessWidget {
  final List<RequestStatusModel> statuses;

  const StatusTimeline({super.key, required this.statuses});

  @override
  Widget build(BuildContext context) {
    if (statuses.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum status encontrado.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.separated(
      itemCount: statuses.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final status = statuses[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _statusLabel(status.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatDate(status.createdAt),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                status.description,
                style: const TextStyle(color: Colors.white),
              ),
              if (status.responsable != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Responsável: ${status.responsable!.name}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/${local.year} $hour:$minute';
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
