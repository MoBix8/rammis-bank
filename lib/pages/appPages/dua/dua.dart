import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rammisbank/utils/theme_data.dart';

class DuaPage extends StatefulWidget {
  const DuaPage({super.key});

  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
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
                      textStyle:
                          TextStyle(color: mainColor, fontSize: width * 0.06)),
                ),
                Container()
              ],
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Center(
              child: Text("data"),
            ),
          ],
        ),
      ),
    );
  }
}
