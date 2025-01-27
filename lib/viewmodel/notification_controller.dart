// /// File: notification_controller.dart
// /// Purpose: 로컬 알림 초기화, 표시 및 권한 요청을 처리하는 서비스 구현
// /// Author: 박민준
// /// Created: 2025-01-02
// /// Last Modified: 2025-01-03 by 박민준
//
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// final FlutterLocalNotificationsPlugin LocalNotifications = FlutterLocalNotificationsPlugin();
//
// Future<void> initializeNotifications() async {
//   AndroidInitializationSettings android =
//   const AndroidInitializationSettings("@mipmap/ic_launcher");
//   DarwinInitializationSettings ios = const DarwinInitializationSettings(
//     requestSoundPermission: false,
//     requestBadgePermission: false,
//     requestAlertPermission: false,
//   );
//   InitializationSettings settings =
//   InitializationSettings(android: android, iOS: ios);
//   await LocalNotifications.initialize(settings);
// }
//
// Future<void> showNotification() async {
//   const AndroidNotificationDetails androidNotificationDetails =
//   AndroidNotificationDetails(
//     'your_channel_id', // 알림 채널 ID
//     'your_channel_name', // 알림 채널 이름
//     channelDescription: 'your_channel_description', // 설명
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//
//   const NotificationDetails notificationDetails =
//   NotificationDetails(android: androidNotificationDetails);
//
//   await LocalNotifications.show(
//     0, // 알림 ID
//     'Hello!', // 제목
//     'This is a test notification.', // 본문
//     notificationDetails,
//   );
// }
//
// Future<void> requestNotificationPermission() async {
//   if (await Permission.notification.isDenied) {
//     await Permission.notification.request();
//   }
// }