import 'package:rammisbank/pages/appPages/adhan/notification_manager/notification_manager.dart';
import 'package:rammisbank/pages/appPages/adhan/notification_manager/objects.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdhanController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;
  String? currentLocation;
  double? latitude;
  double? longitude;
  int? endTime;

  Future<void> prayerTime() async {
    if (storage.read("location") == "" || storage.read("location") == null) {
      currentLocation = storage.read("location");
    }
    Coordinates coordinates = Coordinates(
        // storage.read("lat") == null ? latitude : storage.read("lat"),
        // storage.read("long") == null ? latitude : storage.read("long"),
        // storage.read("long")
        35.78056,
        -78.6389);
    CalculationParameters params = CalculationMethod.MuslimWorldLeague();
    String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    var location = tz.getLocation(currentTimeZone);
    PrayerTimes prayerTimes = PrayerTimes(
        coordinates, tz.TZDateTime.from(DateTime.now(), location), params);

    AdhanReminders adhanReminders =
        AdhanReminders(coordinates: coordinates, params: params);

    adhanReminders.initialization();
    NotificationManager notificationManager = NotificationManager();
    notificationManager.initalize();
    notificationManager.cancelNotification();
    for (var adhanReminder in adhanReminders.adhanReminders) {
      notificationManager.setNotification(
          time: adhanReminder.time,
          id: adhanReminder.id,
          isAdhan: adhanReminder.isAdhan,
          salat: adhanReminder.salat,
          adhan: adhanReminder.adhan);
    }

    DateTime fajr = tz.TZDateTime.from(prayerTimes.fajr!, location);
    DateTime sunrise = tz.TZDateTime.from(prayerTimes.sunrise!, location);
    DateTime dhuhr = tz.TZDateTime.from(prayerTimes.dhuhr!, location);
    DateTime asr = tz.TZDateTime.from(prayerTimes.asr!, location);
    DateTime maghrib = tz.TZDateTime.from(prayerTimes.maghrib!, location);
    DateTime isha = tz.TZDateTime.from(prayerTimes.isha!, location);

    final currentPrayer = prayerTimes.currentPrayer(date: DateTime.now());
    final nextPrayer = prayerTimes.nextPrayer(date: DateTime.now());

    storage.write("fajr", fajr);
    storage.write("sunrise", sunrise);
    storage.write("dhuhr", dhuhr);
    storage.write("asr", asr);
    storage.write("maghrib", maghrib);
    storage.write("isha", isha);
    storage.write("currentPrayer", currentPrayer);
    storage.write("nextPrayer", nextPrayer);
    update();
  }
}
