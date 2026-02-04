import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://andrewmbs.app.n8n.cloud/webhook/travel-request-submit2';

  //  Todos os dados agora dentro de "body"
  final data = {
    "body": {
      "id": "123",
      "name": "Teste",
      "email": "teste@empresa.com",
      "company": "TI",
      "costCenter": "CC-01",
      "origin": "São Paulo",
      "destination": "Brasília",
      "startDate": "01/01/2026",
      "endDate": "03/01/2026",
      "reason": "Teste",
      "status": "Pendente"
    }
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Erro ao enviar dados: $e');
  }
}

