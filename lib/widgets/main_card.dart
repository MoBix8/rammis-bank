import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class MainCard extends StatelessWidget {
  String? img, balance, acc;
  Color? color;
  double? opac;
  MainCard({key, this.img, this.balance, this.acc, this.color, this.opac});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.35,
      width: width * 0.95,
      decoration: BoxDecoration(
          color: color,
          image: DecorationImage(
              image: AssetImage(img!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(opac!), BlendMode.modulate)),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * 0.05, top: height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage("assets/images/rammis2.png"),
                  width: width * 0.4,
                ),
                SizedBox(
                  height: height * 0.015,
                  child: AutoSizeText(
                    "SUSTAINABLE SOURCE OF GROWTH",
                    minFontSize: 8,
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: width * 0.005,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.02),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          SizedBox(
            width: width,
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.02,
                  child: Center(
                    child: AutoSizeText(
                      "BALANCE",
                      minFontSize: 8,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: width * 0.005,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Crash",
                          fontSize: width * 0.03),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.065,
                  child: Center(
                    child: AutoSizeText(
                      balance!,
                      minFontSize: 8,
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: width * 0.005,
                          //fontWeight: FontWeight.bold,
                          fontFamily: "Crash",
                          fontSize: width * 0.1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          SizedBox(
            width: width,
            height: height * 0.03,
            child: Center(
              child: AutoSizeText(
                acc!,
                minFontSize: 8,
                style: TextStyle(
                    color: Colors.white,
                    letterSpacing: width * 0.005,
                    //fontWeight: FontWeight.bold,
                    fontFamily: "Crash",
                    fontSize: width * 0.04),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
