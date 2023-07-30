import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rammisbank/controllers/adhan_controller.dart';
import 'package:rammisbank/controllers/location_controller.dart';
import 'package:rammisbank/pages/appPages/adhan/notification_manager/notification_manager.dart';
import 'package:rammisbank/pages/appPages/adhan/notification_manager/objects.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter_countdown_timer/index.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:change_case/change_case.dart';

class TopContainer extends StatefulWidget {
  const TopContainer({super.key});

  @override
  State<TopContainer> createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {
  LocationController locationController = Get.put(LocationController());
  AdhanController adhanController = Get.put(AdhanController());
  late loc.Location location;
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  late Stream<loc.LocationData> locationData;
  bool isAdhanNotificationGenerated = false;

  final storage = GetStorage();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("not enabled");
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("ever denied");
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    isAdhanNotificationGenerated = false;

    date = DateTime.now();
    params = CalculationMethod.Dubai();
    locationController.getCurrentLocation();
    adhanController.prayerTime();

    getCurrentLocation().then((value) async {
      // lat = "${value.latitude}";
      // long = "${value.longitude}";

      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);

      Placemark place = placemarks[0];

      String currentLocation = "${place.locality}/${place.country}";

      final location = tz.getLocation("America/Detroit");
      DateTime date = tz.TZDateTime.from(DateTime.now(), location);

      coordinates = Coordinates(8.9806, 38.7578);

      CalculationParameters params = CalculationMethod.MuslimWorldLeague();
      prayerTimes = PrayerTimes(coordinates, date, params);

      setState(() {});
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    location = loc.Location();

    return StreamBuilder<loc.LocationData>(
        stream: location.onLocationChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                height: height * 0.3,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/bg-masjid.jpg"),
                        colorFilter: ColorFilter.mode(
                            mainColor.withOpacity(0.5), BlendMode.srcOver),
                        fit: BoxFit.cover)),
                child: Center(
                  child: CircularProgressIndicator(
                    color: mainColor,
                  ),
                ));
          }
          // if (snapshot.hasError) {
          //   return Container(
          //       height: height * 0.3,
          //       width: width,
          //       decoration: BoxDecoration(
          //           image: DecorationImage(
          //               image: AssetImage("assets/images/bg-masjid.jpg"),
          //               colorFilter: ColorFilter.mode(
          //                   mainColor.withOpacity(0.5), BlendMode.srcOver),
          //               fit: BoxFit.cover)),
          //       child: const Center(
          //         child: CircularProgressIndicator(
          //           color: Colors.white,
          //         ),
          //       ));
          // }
          if (snapshot.hasData) {
            snapshot.data;
            coordinates =
                Coordinates(snapshot.data!.latitude, snapshot.data!.longitude);
            prayerTimes =
                PrayerTimes(coordinates, date, params, precision: true);
            locationController.getAddressFromLatLng(
                snapshot.data!.longitude!, snapshot.data!.latitude!);
            if (!isAdhanNotificationGenerated) {
              AdhanReminders adhanReminders = AdhanReminders(
                coordinates: coordinates,
                params: params,
                adhanForFajr: const AdhanForSalat(isAdhanOn: true),
                adhanForDhuhr: const AdhanForSalat(isAdhanOn: true),
                adhanForSunrise: const AdhanForSalat(isAdhanOn: false),
                adhanForAsr: const AdhanForSalat(isAdhanOn: true),
                adhanForMaghrib: const AdhanForSalat(isAdhanOn: true),
                adhanForIsha: const AdhanForSalat(isAdhanOn: true),
              );
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
                isAdhanNotificationGenerated = true;
              }
            }
          }
          String prayer = prayerTimes.nextPrayer();
          int nextPrayerTime =
              prayerTimes.timeForPrayer(prayer)!.millisecondsSinceEpoch;

          bool loading = false;
          var _today = HijriCalendar.fromDate(date);
          List prayers = ["Fajr", "Sunrise", "Dhuhr", "Asr", "Maghrib", "Isha"];
          List adhanTime = [
            prayerTimes.fajr!,
            prayerTimes.sunrise!,
            prayerTimes.dhuhr!,
            prayerTimes.asr!,
            prayerTimes.maghrib!,
            prayerTimes.isha!,
          ];

          CountdownTimerController countController = CountdownTimerController(
            endTime: nextPrayerTime ?? 10,
            onEnd: () {
              loading = true;
              nextPrayerTime =
                  prayerTimes.timeForPrayer(prayer)!.millisecondsSinceEpoch;
              loading = false;
            },
          );
          return Container(
            height: height * 0.3,
            width: width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/bg-masjid.jpg"),
                    colorFilter: ColorFilter.mode(
                        mainColor.withOpacity(0.5), BlendMode.srcOver),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    "${prayerTimes.nextPrayer(date: date)} starts in 36min",
                    style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400)),
                  ),
                  AutoSizeText(
                    prayerTimes
                        .currentPrayer(date: date)
                        .toString()
                        .toCapitalCase(),
                    style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.045,
                            fontWeight: FontWeight.bold,
                            letterSpacing: width * 0.001)),
                  ),
                  AutoSizeText(
                    DateFormat('h:mm a').format(DateTime.now()),
                    style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white, fontSize: height * 0.025)),
                  ),
                  AutoSizeText(
                    storage.read("location"),
                    style: GoogleFonts.ubuntu(
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: height * 0.02,
                            fontWeight: FontWeight.w400,
                            letterSpacing: width * 0.001)),
                  ),
                ],
              ),
            ),
          );
        });

    ;
  }
}
