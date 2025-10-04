import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<String?> getDeviceToken() async {
    return await _fcm.getToken();
  }

  Future<void> requestPermission() async {
    await _fcm.requestPermission();
  }

  void listenToMessages(void Function(RemoteMessage message) onMessage) {
    FirebaseMessaging.onMessage.listen(onMessage);
  }

  void listenToMessageOpenedApp(void Function(RemoteMessage message) onOpened) {
    FirebaseMessaging.onMessageOpenedApp.listen(onOpened);
  }
}
