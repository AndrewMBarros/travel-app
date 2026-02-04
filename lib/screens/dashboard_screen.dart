import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/travel_request.dart';
import '../widgets/travel_card.dart';

class DashboardScreen extends StatefulWidget {
  final List<TravelRequest> requests;
  final String webhookUrl;

  const DashboardScreen({
    super.key,
    required this.requests,
    this.webhookUrl =
        'https://andrewmbs.app.n8n.cloud/webhook-test/path-request',
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<TravelRequest> allRequests;
  late List<TravelRequest> displayedRequests;

  String filter = 'todos'; //  minúsculo
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    allRequests = List.from(widget.requests);
    _applyFilter();
  }

  /// Atualiza status
  Future<void> updateStatus(
    TravelRequest request,
    String newStatus,
  ) async {
    final confirmed = await _confirmAction(newStatus);
    if (!confirmed) return;

    setState(() => isLoading = true);

    final updated = request.copyWith(status: newStatus);

    final index =
        allRequests.indexWhere((r) => r.id == request.id);

    if (index != -1) {
      setState(() {
        allRequests[index] = updated;
        _applyFilter();
      });
    }

    try {
      await http.post(
        Uri.parse(widget.webhookUrl),
        body: {
          'id': updated.id,
          'name': updated.name,
          'origin': updated.origin,
          'destination': updated.destination,
          'dates': updated.dates,
          'status': updated.status,
        },
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// Confirma ações
  Future<bool> _confirmAction(String status) async {
    final label =
        status[0].toUpperCase() + status.substring(1);

    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('$label solicitação'),
            content: Text(
              'Deseja realmente $status esta solicitação?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(label),
              ),
            ],
          ),
        ) ??
        false;
  }

  /// Aplica filtro corretamente
  void _applyFilter() {
    if (filter == 'todos') {
      displayedRequests = List.from(allRequests);
    } else {
      displayedRequests =
          allRequests.where((r) => r.status == filter).toList();
    }
  }

  void changeFilter(String status) {
    setState(() {
      filter = status;
      _applyFilter();
    });
  }

  int countByStatus(String status) =>
      allRequests.where((r) => r.status == status).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de Solicitações')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Indicadores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _indicator('Total', allRequests.length, Colors.blue),
                _indicator(
                  'Pendente',
                  countByStatus('pendente'),
                  Colors.orange,
                ),
                _indicator(
                  'Aprovado',
                  countByStatus('aprovado'),
                  Colors.green,
                ),
                _indicator(
                  'Rejeitado',
                  countByStatus('rejeitado'),
                  Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Filtros
            Wrap(
              spacing: 8,
              children: [
                _filterChip('Todos', 'todos'),
                _filterChip('Pendente', 'pendente'),
                _filterChip('Aprovado', 'aprovado'),
                _filterChip('Rejeitado', 'rejeitado'),
              ],
            ),

            const SizedBox(height: 16),

            // Lista
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : displayedRequests.isEmpty
                      ? const Center(
                          child:
                              Text('Nenhuma solicitação encontrada'),
                        )
                      : ListView.builder(
                          itemCount: displayedRequests.length,
                          itemBuilder: (_, index) {
                            final req = displayedRequests[index];
                            return TravelCard(
                              request: req,
                              onApprove: () =>
                                  updateStatus(req, 'aprovado'),
                              onReject: () =>
                                  updateStatus(req, 'rejeitado'),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: filter == value,
      onSelected: (_) => changeFilter(value),
    );
  }

  Widget _indicator(String label, int value, Color color) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

