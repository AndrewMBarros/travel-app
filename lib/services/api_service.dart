import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/travel_request.dart';

class ApiService {
  static const String _createRequestUrl =
      'https://andrewmbs.app.n8n.cloud/webhook/travel-request-submit2';

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Criar solicitação de viagem
  static Future<bool> createTravelRequest(TravelRequest request) async {
    final url = Uri.parse(_createRequestUrl);

    // payload flat
    final payload = request.toJsonFlat();

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Solicitação enviada com sucesso!');
        return true;
      } else {
        print(
            'Erro ao criar solicitação (${response.statusCode}): ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro na requisição (createTravelRequest): $e');
      return false;
    }
  }

  /// Listar solicitações de um usuário
  static Future<List<TravelRequest>> getTravelRequests(String userId) async {
    final url = Uri.parse(
        'https://andrewmbs.app.n8n.cloud/webhook-test/travel-requests?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List data = jsonDecode(response.body);
        return data.map((e) => TravelRequest.fromJson(e)).toList();
      } else {
        print(
            'Erro ao buscar solicitações (${response.statusCode}): ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição (getTravelRequests): $e');
      return [];
    }
  }

  /// Aprovar ou rejeitar solicitação
  static Future<bool> approveTravelRequest({
    required String requestId,
    required bool approved,
    String? comment,
  }) async {
    final url = Uri.parse(
        'https://andrewmbs.app.n8n.cloud/webhook-test/approve-travel');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: jsonEncode({
          'requestId': requestId,
          'approved': approved,
          'comment': comment ?? '',
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print(
            'Erro ao aprovar solicitação (${response.statusCode}): ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro na requisição (approveTravelRequest): $e');
      return false;
    }
  }
}
