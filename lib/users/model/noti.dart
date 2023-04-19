import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async{
  const AndroidInitializationSettings initializationSettingsAndroid = 
  AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


Future<void> mostrarNotificacion() async{

  const AndroidNotificationDetails androidNotificationDetails = 
  AndroidNotificationDetails('chanel id', 'your_chanel_ame', importance: Importance.max, priority: Priority.high, playSound: true);

   const NotificationDetails notificationDetails =  NotificationDetails(
    android: androidNotificationDetails,
   );

   await flutterLocalNotificationsPlugin.show(
    1, 
   'INFORME PT&I', 
   'Descargado correctamente', 
    notificationDetails);
}