import 'package:flutter/material.dart';
import '../models/travel_request.dart';
import 'status_badge.dart';

class TravelCard extends StatelessWidget {
  final TravelRequest request;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const TravelCard({
    Key? key,
    required this.request,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome
            Text(
              request.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),

            // Origem → Destino
            Text(
              '${request.origin} → ${request.destination}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),

            // Datas
            Text(
              request.dates,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 12),

            // Status + Botões
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: request.status),
                if (request.status == 'Pendente')
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(80, 36),
                        ),
                        child: const Text(
                          'Aprovar',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: onReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size(80, 36),
                        ),
                        child: const Text(
                          'Rejeitar',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
