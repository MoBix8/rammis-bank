import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:get/get.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ism_logo');

const InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
);

class NotificationManager {
  initalize() async {
    void selectNotification(String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: $payload');
      }
      await Get.to(NotificationPage(payload: payload!));
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    // onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  // void onDidReceiveNotificationResponse(
  //     NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     debugPrint('notification payload: $payload');
  //   }

  //   await Get.to(NotificationPage(payload: payload!));
  // }

  setNotification(
      {required DateTime time,
      required int id,
      required bool isAdhan,
      required String salat,
      required String adhan}) async {
    tz.initializeTimeZones();
    Duration duration = time.difference(DateTime.now());
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        "$salat Prayer Time",
        "It's time for $salat Prayer, Pray at the time",
        tz.TZDateTime.now(tz.local).add(time.difference(DateTime.now())),
        NotificationDetails(
            android: AndroidNotificationDetails(
                DateTime.now().millisecondsSinceEpoch.toString(), "channelName",
                channelDescription: "Adhan For Prayer",
                playSound: isAdhan,
                importance: Importance.max,
                priority: Priority.high,
                fullScreenIntent: true,
                sound: RawResourceAndroidNotificationSound(adhan))),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: "Salat");
  }

  cancelNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }
}

class NotificationPage extends StatelessWidget {
  final String payload;
  const NotificationPage({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person,
              size: _height * 0.4,
            ),
            Text(
                "Alhamdulilah, It's time for ${payload}, May allah Bless you and all around you.")
          ],
        ),
      ),
    );
  }
}
