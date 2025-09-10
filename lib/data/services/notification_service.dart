// Push notifications (se usar FCM)
// lib/data/services/notification_service.dart
// UTF-8

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço de envio de notificações push via Firebase Cloud Messaging (FCM).
/// Necessário configurar a **Server Key** do Firebase no backend.
/// ATENÇÃO: nunca exponha a Server Key direto no app final.
/// Use apenas para testes locais.
/// Para produção → crie uma Cloud Function para intermediar.

class NotificationService {
  static const String _fcmEndpoint = "https://fcm.googleapis.com/fcm/send";

  /// ⚠️ Substituir pela sua SERVER KEY do Firebase
  static const String _serverKey = "COLE_SUA_SERVER_KEY_AQUI";

  /// Envia notificação para um **dispositivo específico** (via token).
  static Future<bool> sendToToken({
    required String token,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$_serverKey",
        },
        body: jsonEncode({
          "to": token,
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro ao enviar notificação: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro inesperado ao enviar notificação: $e");
      return false;
    }
  }

  /// Envia notificação para um **tópico** (ex.: todos inscritos em "clientes").
  static Future<bool> sendToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_fcmEndpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "key=$_serverKey",
        },
        body: jsonEncode({
          "to": "/topics/$topic",
          "notification": {
            "title": title,
            "body": body,
          },
          "data": data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Erro ao enviar notificação para tópico: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro inesperado ao enviar notificação para tópico: $e");
      return false;
    }
  }
}
