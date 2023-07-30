import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rammisbank/pages/appPages/qibla/loading_indicator.dart';
import 'package:rammisbank/pages/appPages/qibla/qiblah_compass.dart';
import 'package:rammisbank/pages/appPages/qibla/qiblah_maps.dart';
import 'package:rammisbank/utils/theme_data.dart';

import 'package:flutter_qiblah/flutter_qiblah.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});

  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        size: width * 0.05,
                      )),
                  AutoSizeText(
                    "Duas",
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: mainColor, fontSize: width * 0.06)),
                  ),
                  Container()
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              SizedBox(
                height: height * 0.9,
                child: FutureBuilder(
                    future: _deviceSupport,
                    builder: (_, AsyncSnapshot<bool?> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return LoadingIndicator();
                      if (snapshot.hasError)
                        return Center(
                          child: Text("Error: ${snapshot.error.toString()}"),
                        );

                      if (snapshot.data!)
                        return QiblahCompass();
                      else
                        // return QiblahMaps();
                        return Text("Device Doesn't support");
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
