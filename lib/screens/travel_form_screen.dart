import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/travel_request.dart';
import '../services/api_service.dart';
import '../widgets/primary_button.dart';
import 'dashboard_screen.dart';

class TravelFormScreen extends StatefulWidget {
  final List<TravelRequest> previousRequests;

  const TravelFormScreen({super.key, this.previousRequests = const []});

  @override
  State<TravelFormScreen> createState() => _TravelFormScreenState();
}

class _TravelFormScreenState extends State<TravelFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  String name = '';
  String email = '';
  String company = '';
  String costCenter = '';
  String origin = '';
  String destination = '';
  DateTime? startDate;
  DateTime? endDate;
  String reason = '';

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  /// 🔔 Dialog de Aprovação/Rejeição
  Future<String?> _showApprovalDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Status da Solicitação'),
        content: const Text('Deseja aprovar ou rejeitar esta solicitação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'rejeitado'),
            child: const Text(
              'Rejeitar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'aprovado'),
            child: const Text('Aprovar'),
          ),
        ],
      ),
    );
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    if (startDate != null &&
        endDate != null &&
        endDate!.isBefore(startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A data final não pode ser anterior à data inicial'),
        ),
      );
      return;
    }

    final newRequest = TravelRequest(
      id: '',
      name: name,
      email: email,
      company: company,
      costCenter: costCenter,
      origin: origin,
      destination: destination,
      startDate: DateFormat('dd/MM/yyyy').format(startDate!),
      endDate: DateFormat('dd/MM/yyyy').format(endDate!),
      reason: reason,
      status: 'pendente',
    );

    final success = await ApiService.createTravelRequest(newRequest);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao enviar solicitação')),
      );
      return;
    }

    final statusEscolhido = await _showApprovalDialog();
    if (statusEscolhido == null) return;

    final updatedRequest = TravelRequest(
      id: newRequest.id,
      name: newRequest.name,
      email: newRequest.email,
      company: newRequest.company,
      costCenter: newRequest.costCenter,
      origin: newRequest.origin,
      destination: newRequest.destination,
      startDate: newRequest.startDate,
      endDate: newRequest.endDate,
      reason: newRequest.reason,
      status: statusEscolhido.toLowerCase(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Solicitação ${statusEscolhido[0].toUpperCase()}${statusEscolhido.substring(1)} com sucesso!',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DashboardScreen(
          requests: [updatedRequest, ...widget.previousRequests],
        ),
      ),
    );
  }

  Future<void> pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        startDate = picked;
        startDateController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      } else {
        endDate = picked;
        endDateController.text =
            DateFormat('dd/MM/yyyy').format(picked);
      }
    });
  }

  String? validateEmail(String? val) {
    if (val == null || val.isEmpty) return 'Informe seu e-mail';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(val)) return 'E-mail inválido';
    return null;
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _input(String label, {required Function(String) onSaved}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (v) =>
          v == null || v.isEmpty ? 'Campo obrigatório' : null,
      onSaved: (v) => onSaved(v!),
    );
  }

  Widget _emailInput() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'E-mail'),
      keyboardType: TextInputType.emailAddress,
      validator: validateEmail,
      onSaved: (v) => email = v!,
    );
  }

  Widget _dateInput(
    String label,
    TextEditingController controller,
    VoidCallback onTap,
  ) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (v) => v == null || v.isEmpty ? 'Informe a data' : null,
      onTap: onTap,
    );
  }

  Widget _reasonInput() {
    return TextFormField(
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: 'Motivo da viagem',
        alignLabelWithHint: true,
      ),
      validator: (v) =>
          v == null || v.isEmpty ? 'Informe o motivo' : null,
      onSaved: (v) => reason = v!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitação de Viagem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _sectionTitle('Dados do solicitante'),
              _input('Nome completo', onSaved: (v) => name = v),
              _emailInput(),
              _input('Empresa / Setor', onSaved: (v) => company = v),
              _input('Centro de Custo', onSaved: (v) => costCenter = v),

              _sectionTitle('Dados da viagem'),
              _input('Origem', onSaved: (v) => origin = v),
              _input('Destino', onSaved: (v) => destination = v),
              _dateInput(
                'Data de início',
                startDateController,
                () => pickDate(true),
              ),
              _dateInput(
                'Data de fim',
                endDateController,
                () => pickDate(false),
              ),

              _sectionTitle('Justificativa'),
              _reasonInput(),

              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Enviar Solicitação',
                onPressed: submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
