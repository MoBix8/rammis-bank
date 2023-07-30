// ignore: file_names
import 'package:adhan_dart/adhan_dart.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rammisbank/controllers/adhan_controller.dart';
import 'package:rammisbank/controllers/location_controller.dart';
import 'package:rammisbank/pages/appPages/dua/dua.dart';
import 'package:rammisbank/pages/appPages/qibla/qibla.dart';

import 'package:rammisbank/pages/appPages/quran/quran_page.dart';
import 'package:rammisbank/utils/islamic_apps.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:abushakir/abushakir.dart';
import 'package:rammisbank/widgets/top_container.dart';
import 'package:timezone/timezone.dart' as tz;
// import 'package:pray_times/pray_times.dart';

class Islamic extends StatefulWidget {
  const Islamic({super.key});

  @override
  State<Islamic> createState() => _IslamicState();
}

class _IslamicState extends State<Islamic> {
  LocationController locationController = Get.put(LocationController());
  AdhanController adhanController = Get.put(AdhanController());

  late String lat;
  late String long;
  // late List<String> prayerTimes;
  late PrayerTimes prayerTimes;
  late Coordinates coordinates;

  var hijra = HijriCalendar.now();
  EtDatetime ethio = new EtDatetime.now();

  final storage = GetStorage();
  // PrayerTimes prayers = PrayerTimes();

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
    // TODO: implement initState
    super.initState();
    locationController.getCurrentLocation();
    adhanController.prayerTime();

    // prayers.setTimeFormat(prayers.Time24);
    // prayers.setCalcMethod(prayers.MWL);
    // prayers.setAsrJuristic(prayers.Shafii);
    // prayers.setAdjustHighLats(prayers.AngleBased);

    // var offsets = [0, 0, 0, 0, 0, 0, 0];
    // prayers.tune(offsets);
    // final date = DateTime.now();

    // getCurrentLocation().then((value) async {
    //   lat = "${value.latitude}";
    //   long = "${value.longitude}";

    //   List<Placemark> placemarks =
    //       await placemarkFromCoordinates(value.latitude, value.longitude);

    //   Placemark place = placemarks[0];

    //   String currentLocation = "${place.locality}/${place.country}";

    //   final location = tz.getLocation("America/Detroit");
    //   DateTime date = tz.TZDateTime.from(DateTime.now(), location);

    //   coordinates = Coordinates(8.9806, 38.7578);

    //   CalculationParameters params = CalculationMethod.MuslimWorldLeague();
    //   prayerTimes = PrayerTimes(coordinates, date, params);

    //   print("././././././././././././");
    //   print(prayerTimes.currentPrayer(date: date));

    //   // prayerTimes =
    //   //     prayers.getPrayerTimes(date, value.latitude, value.longitude, 3);

    //   // print(prayerTimes);
    //   // print("./././././././././././/././././././/.//./");

    //   // CalculationParameters params = CalculationMethod.MuslimWorldLeague();
    //   // coordinates = Coordinates(value.latitude, value.longitude);
    //   // prayerTimes = PrayerTimes(coordinates, date, params);

    //   setState(() {});
    // }
    // );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: height * 0.35,
                width: width,
                child: Stack(
                  children: [
                    TopContainer(),

                    // Container(
                    //   height: height * 0.3,
                    //   width: width,
                    //   decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage("assets/images/bg-masjid.jpg"),
                    //           colorFilter: ColorFilter.mode(
                    //               mainColor.withOpacity(0.5),
                    //               BlendMode.srcOver),
                    //           fit: BoxFit.cover)),
                    //   child: Padding(
                    //     padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         AutoSizeText(
                    //           "Isha starts in 36min",
                    //           style: GoogleFonts.ubuntu(
                    //               textStyle: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: height * 0.02,
                    //                   fontWeight: FontWeight.w400)),
                    //         ),
                    //         AutoSizeText(
                    //           "Maghrib",
                    //           // prayerTimes[0],
                    //           // prayerTimes.currentPrayer(date: DateTime.now()),
                    //           // "${coordinates.latitude}",
                    //           style: GoogleFonts.ubuntu(
                    //               textStyle: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: height * 0.045,
                    //                   fontWeight: FontWeight.bold,
                    //                   letterSpacing: width * 0.001)),
                    //         ),
                    //         AutoSizeText(
                    //           DateFormat('h:mm a').format(DateTime.now()),
                    //           style: GoogleFonts.ubuntu(
                    //               textStyle: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: height * 0.025)),
                    //         ),
                    //         AutoSizeText(
                    //           "Addis Ababa",
                    //           style: GoogleFonts.ubuntu(
                    //               textStyle: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize: height * 0.02,
                    //                   fontWeight: FontWeight.w400,
                    //                   letterSpacing: width * 0.001)),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Container(
                          width: width,
                          height: height * 0.1,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 9,
                                    offset: Offset(0, 3))
                              ]),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Center(
                                child: AutoSizeText(
                                  "${hijra.hDay} ${hijra.getLongMonthName()} ${hijra.hYear}",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: mainColor,
                                          fontSize: height * 0.02)),
                                ),
                              )),
                              VerticalDivider(
                                thickness: width * 0.001,
                                color: Colors.black26,
                              ),
                              Expanded(
                                  child: Center(
                                child: AutoSizeText(
                                  "${ethio.day} ${ethio.monthGeez} ${ethio.year}",
                                  style: GoogleFonts.ubuntu(
                                      textStyle: TextStyle(
                                          color: mainColor,
                                          fontSize: height * 0.02)),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.01),
                child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: width * 0.04,
                        mainAxisSpacing: width * 0.02),
                    itemCount: Apps.AppsList().length,
                    itemBuilder: (context, index) {
                      final apps = Apps.AppsList();
                      return InkWell(
                        onTap: () {
                          if (index == 0) {
                            Get.to(QuranPage());
                          } else if (index == 2) {
                            Get.to(QiblaPage());
                          } else if (index == 3) {
                            Get.to(DuaPage());
                          }
                        },
                        child: Container(
                          // aspectRatio: 1.5,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  // height: height * 0.05,
                                  // width: height * 0.05,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 3,
                                            blurRadius: 3,
                                            offset: Offset(0, 3))
                                      ]),
                                  child: Padding(
                                    padding: EdgeInsets.all(height * 0.01),
                                    child: Center(
                                      child: Image.asset(
                                        apps[index].img,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.01),
                                child: AutoSizeText(
                                  apps[index].name,
                                  style: GoogleFonts.quicksand(
                                      textStyle: TextStyle(
                                          color: mainColor,
                                          fontSize: width * 0.03)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
