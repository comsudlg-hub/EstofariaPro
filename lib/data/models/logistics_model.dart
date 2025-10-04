class LogisticsModel {
  final String id;
  final String orderId;
  final String status; // em_producao | em_transporte | concluida
  final DateTime? dataEntrega;
  final String? responsavel;

  LogisticsModel({
    required this.id,
    required this.orderId,
    required this.status,
    this.dataEntrega,
    this.responsavel,
  });

  factory LogisticsModel.fromMap(Map<String, dynamic> map, String documentId) {
    return LogisticsModel(
      id: documentId,
      orderId: map['orderId'] ?? '',
      status: map['status'] ?? 'em_producao',
      dataEntrega: map['dataEntrega'] != null
          ? DateTime.tryParse(map['dataEntrega'])
          : null,
      responsavel: map['responsavel'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'status': status,
      'dataEntrega': dataEntrega?.toIso8601String(),
      'responsavel': responsavel,
    };
  }
}
