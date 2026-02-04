class TravelRequest {
  final String id;
  final String name;
  final String email;
  final String company;
  final String costCenter;
  final String origin;
  final String destination;
  final String startDate;
  final String endDate;
  final String reason;
  final String status;
  final String createdAt;
  final String approvedBy;
  final String approvalComment;
  final String approvedAt;

  TravelRequest({
    String? id,
    required this.name,
    required this.email,
    required this.company,
    required this.costCenter,
    required this.origin,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.reason,
    String? status,
    String? createdAt,
    String? approvedBy,
    String? approvalComment,
    String? approvedAt,
  })  : id = id ?? '',
        status = _normalizeStatus(status),
        createdAt = createdAt ?? DateTime.now().toIso8601String(),
        approvedBy = approvedBy ?? '',
        approvalComment = approvalComment ?? '',
        approvedAt = approvedAt ?? '';

  /// Normaliza qualquer status vindo do n8n / Sheets
  static String _normalizeStatus(dynamic value) {
    final s = value?.toString().trim().toLowerCase();

    switch (s) {
      case 'aprovado':
      case 'approved':
        return 'aprovado';
      case 'rejeitado':
      case 'rejected':
        return 'rejeitado';
      case 'pendente':
      case 'pending':
      default:
        return 'pendente';
    }
  }

  /// Datas formatadas para UI
  String get dates => '$startDate - $endDate';

  /// Atualiza campos
  TravelRequest copyWith({
    String? id,
    String? name,
    String? email,
    String? company,
    String? costCenter,
    String? origin,
    String? destination,
    String? startDate,
    String? endDate,
    String? reason,
    String? status,
    String? createdAt,
    String? approvedBy,
    String? approvalComment,
    String? approvedAt,
  }) {
    return TravelRequest(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      company: company ?? this.company,
      costCenter: costCenter ?? this.costCenter,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedBy: approvedBy ?? this.approvedBy,
      approvalComment: approvalComment ?? this.approvalComment,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  /// JSON interno
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'company': company,
      'costCenter': costCenter,
      'origin': origin,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'reason': reason,
      'status': status,
      'createdAt': createdAt,
      'approvedBy': approvedBy,
      'approvalComment': approvalComment,
      'approvedAt': approvedAt,
    };
  }

  /// JSON flat para n8n / Google Sheets
  Map<String, dynamic> toJsonFlat() {
    return {
      'request_id': id,
      'employee_name': name,
      'employee_email': email,
      'company_sector': company,
      'cost_center': costCenter,
      'origin': origin,
      'destination': destination,
      'start_date': startDate,
      'end_date': endDate,
      'travel_reason': reason,
      'status': status,
      'created_at': createdAt,
      'approved_by': approvedBy,
      'approval_comment': approvalComment,
      'approved_at': approvedAt,
    };
  }

  ///  Converte snake_case OU camelCase (n8n / Sheets / API)
  factory TravelRequest.fromMap(Map<String, dynamic> map) {
    return TravelRequest(
      id: map['id'] ?? map['request_id'] ?? '',
      name: map['name'] ?? map['employee_name'] ?? '',
      email: map['email'] ?? map['employee_email'] ?? '',
      company: map['company'] ?? map['company_sector'] ?? '',
      costCenter: map['costCenter'] ?? map['cost_center'] ?? '',
      origin: map['origin'] ?? '',
      destination: map['destination'] ?? '',
      startDate: map['startDate'] ?? map['start_date'] ?? '',
      endDate: map['endDate'] ?? map['end_date'] ?? '',
      reason: map['reason'] ?? map['travel_reason'] ?? '',
      status: map['status'],
      createdAt: map['createdAt'] ?? map['created_at'],
      approvedBy: map['approvedBy'] ?? map['approved_by'],
      approvalComment:
          map['approvalComment'] ?? map['approval_comment'],
      approvedAt: map['approvedAt'] ?? map['approved_at'],
    );
  }

  factory TravelRequest.fromJson(Map<String, dynamic> json) =>
      TravelRequest.fromMap(json);
}

