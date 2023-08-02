import 'package:adhan_dart/adhan_dart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart' as loc;
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:rammisbank/controllers/adhan_controller.dart';
import 'package:rammisbank/controllers/location_controller.dart';
import 'package:rammisbank/pages/appPages/adhan/notification_manager/notification_manager.dart';
import 'package:rammisbank/pages/appPages/adhan/notification_manager/objects.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:timezone/timezone.dart' as tz;

class AdhanPage extends StatefulWidget {
  const AdhanPage({super.key});

  @override
  State<AdhanPage> createState() => _AdhanPageState();
}

List months = [
  "Jan",
  "Feb",
  "Mrch",
  "Apl",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

class _AdhanPageState extends State<AdhanPage> {
  LocationController locationController = Get.put(LocationController());
  AdhanController adhanController = Get.put(AdhanController());
  bool loading = true;

  late loc.Location location;
  late PrayerTimes prayerTimes;
  late DateTime date;
  late Coordinates coordinates;
  late CalculationParameters params;
  late Stream<loc.LocationData> locationData;
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

  bool isAdhanNotificationGenerated = false;
  @override
  void initState() {
    isAdhanNotificationGenerated = false;
    locationController.getCurrentLocation();
    adhanController.prayerTime();
    date = DateTime.now();
    params = CalculationMethod.Dubai();
    getCurrentLocation().then((value) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);

      // final location = tz.getLocation("America/Detroit");
      final location = tz.getLocation("Africa/Addis_Ababa");
      DateTime date = tz.TZDateTime.from(DateTime.now(), location);

      coordinates = await Coordinates(8.9806, 38.7578);

      CalculationParameters params =
          await CalculationMethod.MuslimWorldLeague();
      prayerTimes = await PrayerTimes(coordinates, date, params);

      setState(() {
        loading = false;
      });
    });
    //prayerTimes = PrayerTimes(coordinates, date, params, precision: true);
    super.initState();
  }

  String timePresenter(DateTime dateTime) {
    String timeInString = "";
    bool isGreaterThan12 = dateTime.hour > 12;
    String prefix = dateTime.hour > 11 ? "pm" : "am";

    int hour = isGreaterThan12 ? dateTime.hour - 12 : dateTime.hour;
    int minute = dateTime.minute;
    String hourInString = hour.toString().length == 1 ? "0$hour" : "$hour";
    String minuteInString =
        minute.toString().length == 1 ? "0$minute" : "$minute";
    return "$hourInString:$minuteInString $prefix";
  }

  remainsTime() async* {
    yield* Stream.periodic(Duration(seconds: 1), (t) {
      String prayer = prayerTimes.nextPrayer();
      DateTime nextPrayerTime = prayerTimes.timeForPrayer(prayer)!.toLocal();
      DateTime now = DateTime.now();
      Duration remains = nextPrayerTime.difference(now);
      return secondToHour(remains.inSeconds);
    });
  }

  secondToHour(int seconds) {
    int minutes = seconds ~/ 60;
    int hours = minutes ~/ 60;
    seconds = seconds - minutes * 60;
    minutes = minutes - hours * 60;
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final _appbar = AppBar().preferredSize.height;
    location = loc.Location();

    return loading
        ? Container(
            height: height,
            width: width,
            child: Center(
              child: CircularProgressIndicator(
                color: mainColor,
              ),
            ))
        : StreamBuilder<loc.LocationData>(
            stream: location.onLocationChanged,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              List bells = [
                storage.read("isAdhanFajr") ?? true,
                storage.read("isAdhanSunrise") ?? false,
                storage.read("isAdhanDhuhr") ?? true,
                storage.read("isAdhanAsr") ?? true,
                storage.read("isAdhanMaghrib") ?? true,
                storage.read("isAdhanIsha") ?? true,
              ];

              if (snapshot.hasData) {
                snapshot.data;
                coordinates = Coordinates(
                    snapshot.data!.latitude, snapshot.data!.longitude);
                prayerTimes =
                    PrayerTimes(coordinates, date, params, precision: true);
                locationController.getAddressFromLatLng(
                    snapshot.data!.longitude!, snapshot.data!.latitude!);

                if (!isAdhanNotificationGenerated) {
                  // storage.write("fajrAdhan", value)
                  AdhanReminders adhanReminders = AdhanReminders(
                    coordinates: coordinates,
                    params: params,
                    adhanForFajr: AdhanForSalat(isAdhanOn: bells[0]),
                    adhanForSunrise: AdhanForSalat(isAdhanOn: bells[1]),
                    adhanForDhuhr: AdhanForSalat(isAdhanOn: bells[2]),
                    adhanForAsr: AdhanForSalat(isAdhanOn: bells[3]),
                    adhanForMaghrib: AdhanForSalat(isAdhanOn: bells[4]),
                    adhanForIsha: AdhanForSalat(isAdhanOn: bells[5]),
                  );
                  adhanReminders.initialization();
                  NotificationManager notificationManager =
                      NotificationManager();
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
              List prayers = [
                "Fajr",
                "Sunrise",
                "Dhuhr",
                "Asr",
                "Maghrib",
                "Isha"
              ];

              List adhanTime = [
                prayerTimes.fajr!,
                prayerTimes.sunrise!,
                prayerTimes.dhuhr!,
                prayerTimes.asr!,
                prayerTimes.maghrib!,
                prayerTimes.isha!,
              ];

              CountdownTimerController countController =
                  CountdownTimerController(
                endTime: nextPrayerTime ?? 10,
                onEnd: () {
                  setState(() {
                    loading = true;
                    nextPrayerTime = prayerTimes
                        .timeForPrayer(prayer)!
                        .millisecondsSinceEpoch;
                    loading = false;
                  });
                },
              );

              return Scaffold(
                body: Container(
                  height: height,
                  width: width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        opacity: 0.2,
                        alignment: Alignment.bottomCenter,
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/adhan-bg.jpg")),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: height * 0.05,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.04),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(CupertinoIcons.back)),
                              SizedBox(
                                width: width * 0.6,
                                child: const Center(
                                  child: Text("PRAYER TIMES"),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(CupertinoIcons.gear)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        loading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : CountdownTimer(
                                controller: countController,
                                // endTime: (prayerTimes
                                //     .timeForPrayer(prayer)!
                                //     .millisecondsSinceEpoch),
                                widgetBuilder: (context, time) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        time!.hours.toString() == "null"
                                            ? "0"
                                            : time.hours.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.1),
                                      ),
                                      Text(
                                        " hour ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: width * 0.08),
                                      ),
                                      Text(
                                        time.min.toString() == "null"
                                            ? "0"
                                            : time.min.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.09),
                                      ),
                                      Text(
                                        " minutes",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: width * 0.08),
                                      ),
                                    ],
                                  );
                                },
                                textStyle: TextStyle(
                                    fontSize: width * 0.045,
                                    fontWeight: FontWeight.w500),
                                endWidget: Text(
                                    "It's time for ${prayerTimes.currentPrayer(date: date)}"),
                              ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Left until ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: width * 0.035),
                            ),
                            Text(
                              toBeginningOfSentenceCase(
                                  prayerTimes.nextPrayer())!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: width * 0.04),
                            )
                          ],
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          height: height * 0.055,
                          width: width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: height * 0.025,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: width * 0.01,
                              ),
                              AutoSizeText(
                                storage.read("location"),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: width * 0.032),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            date.isAfter(DateTime.now())
                                ? InkWell(
                                    onTap: () {
                                      date = date.add(Duration(days: -1));
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.arrow_left,
                                      size: width * 0.1,
                                      color: Colors.white,
                                    ),
                                  )
                                : Container(
                                    width: width * 0.1,
                                  ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat.yMMMMd('en_US').format(date),
                                    style: TextStyle(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: width * 0.004),
                                  ),
                                  Text(
                                    "${_today.hDay} ${_today.longMonthName} ${_today.hYear}",
                                    style: TextStyle(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: width * 0.003),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                date = date.add(Duration(days: 1));
                                setState(() {});
                              },
                              child: Icon(
                                Icons.arrow_right,
                                size: width * 0.1,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        ListView.builder(
                            itemCount: prayers.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03),
                                child: ListTile(
                                  leading: bells[index] == true
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              bells[index] = false;
                                              storage.write(
                                                  "isAdhan${prayers[index]}",
                                                  false);
                                            });
                                          },
                                          icon: Icon(CupertinoIcons.bell))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              bells[index] = true;
                                              storage.write(
                                                  "isAdhan${prayers[index]}",
                                                  true);
                                            });
                                          },
                                          icon:
                                              Icon(CupertinoIcons.bell_slash)),
                                  title: Text(prayers[index]),
                                  trailing: Text(timePresenter(
                                      adhanTime[index].toLocal())),
                                  // trailing: Text(DateFormat.jm(date1).toString()),
                                ),
                              );
                            })),
                      ],
                    ),
                  ),
                ),
              );
            });
  }
}
