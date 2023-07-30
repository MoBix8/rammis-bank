import 'package:adhan_dart/adhan_dart.dart';
import 'package:get_storage/get_storage.dart';

final storage = GetStorage();

class AdhanForSalat {
  final bool isAdhanOn;
  final String adhanName;
  const AdhanForSalat({this.isAdhanOn = true, this.adhanName = "azan1"});
}

class AdhanReminders {
  AdhanForSalat adhanForFajr;
  AdhanForSalat adhanForSunrise;
  AdhanForSalat adhanForDhuhr;
  AdhanForSalat adhanForAsr;
  AdhanForSalat adhanForMaghrib;
  AdhanForSalat adhanForIsha;
  Coordinates coordinates;
  CalculationParameters params;

  AdhanReminders(
      {this.adhanForFajr = const AdhanForSalat(),
      this.adhanForSunrise = const AdhanForSalat(),
      this.adhanForDhuhr = const AdhanForSalat(),
      this.adhanForAsr = const AdhanForSalat(),
      this.adhanForMaghrib = const AdhanForSalat(),
      this.adhanForIsha = const AdhanForSalat(),
      required this.coordinates,
      required this.params});

  List<AdhanReminder> adhanReminders = [];

  initialization() {
    for (var i = 0; i < 7; i++) {
      DateTime dateTime = DateTime.now().add(Duration(days: i));

      PrayerTimes prayerTimes =
          PrayerTimes(coordinates, dateTime, params, precision: true);
      if (adhanForFajr.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForFajr.adhanName,
            isAdhan: adhanForFajr.isAdhanOn,
            id: 1 + 6 * i,
            salat: "Fajr",
            time: prayerTimes.fajr!));
      }
      if (adhanForSunrise.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForSunrise.adhanName,
            isAdhan: adhanForSunrise.isAdhanOn,
            id: 2 + 6 * i,
            salat: "Sunrise",
            time: prayerTimes.sunrise!));
      }
      if (adhanForDhuhr.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForDhuhr.adhanName,
            isAdhan: adhanForDhuhr.isAdhanOn,
            id: 3 + 6 * i,
            salat: "Dhuhr",
            time: prayerTimes.dhuhr!));
      }
      if (adhanForAsr.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForAsr.adhanName,
            isAdhan: adhanForAsr.isAdhanOn,
            id: 4 + 6 * i,
            salat: "Asr",
            time: prayerTimes.asr!));
      }
      if (adhanForMaghrib.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForMaghrib.adhanName,
            isAdhan: adhanForMaghrib.isAdhanOn,
            id: 5 + 6 * i,
            salat: "Maghrib",
            time: prayerTimes.maghrib!));
      }
      if (adhanForIsha.isAdhanOn) {
        adhanReminders.add(AdhanReminder(
            adhan: adhanForIsha.adhanName,
            isAdhan: adhanForIsha.isAdhanOn,
            id: 6 + 6 * i,
            salat: "Isha",
            time: prayerTimes.isha!));
      }
    }
  }
}

class AdhanReminder {
  int id;
  String adhan;
  bool isAdhan;
  String salat;
  DateTime time;
  AdhanReminder(
      {required this.adhan,
      required this.id,
      required this.isAdhan,
      required this.salat,
      required this.time});
}
