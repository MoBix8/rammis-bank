import 'package:auto_size_text/auto_size_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rammisbank/utils/theme_data.dart';

class HistoryDialog extends StatelessWidget {
  String? name, type, amount, sendAcc, recAcc, reason;
  DateTime? date;

  HistoryDialog(this.amount, this.date, this.name, this.reason, this.recAcc,
      this.sendAcc, this.type);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: height * 0.01,
          width: width * 0.8,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.04,
                width: width * 0.3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(type!.toUpperCase(),
                      minFontSize: 8,
                      style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: secColor,
                          letterSpacing: width * 0.004)),
                ),
              ),
              SizedBox(
                height: height * 0.04,
                width: width * 0.3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(DateFormat.yMd().format(date!).toString(),
                      minFontSize: 8,
                      style: TextStyle(
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.w600,
                          color: secColor,
                          letterSpacing: width * 0.004)),
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText("Name:",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(name!,
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
          ],
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText("From:",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(sendAcc!,
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
          ],
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText("To:",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(recAcc!,
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
          ],
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText("Amount:",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(amount! + " ETB",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
          ],
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.04,
              width: width * 0.2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AutoSizeText("Reason:",
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
            SizedBox(
              height: height * 0.04,
              width: width * 0.5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AutoSizeText(reason!,
                    minFontSize: 8,
                    style: TextStyle(
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w500,
                        color: secColor,
                        letterSpacing: width * 0.004)),
              ),
            ),
          ],
        ),
        Divider(
          height: height * 0.01,
          //color: secColor,
          thickness: height * 0.001,
        ),
      ],
    );
  }
}
