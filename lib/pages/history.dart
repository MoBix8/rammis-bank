import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:rammisbank/utils/history_list.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:rammisbank/widgets/history_dialog.dart';
import 'package:unicons/unicons.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final TimerController _timerController = Get.put(TimerController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(height * 0.07),
            child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: Padding(
                  padding: EdgeInsets.only(left: width * 0.08),
                  child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.1),
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.fill,
                        ),
                      ))),
              actions: [
                Padding(
                  padding: EdgeInsets.only(right: width * 0.02),
                  child: IconButton(
                      onPressed: () {
                        _timerController.startTimer();
                        _timerController.setLocked(true);
                      },
                      icon: Icon(
                        UniconsSolid.lock,
                        color: mainColor,
                      )),
                )
              ],
            )),
        body: ListView.builder(
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            itemCount: Histories.HistoryList().length,
            itemBuilder: (context, index) {
              var history = Histories.HistoryList();
              return Column(children: [
                SizedBox(
                  height: height * 0.01,
                ),
                InkWell(
                  onTap: () {
                    Get.defaultDialog(
                        buttonColor: mainColor,
                        cancelTextColor: mainColor,
                        title: "History Detail",
                        onCancel: () async {
                          Get.back();
                        },
                        textCancel: "Dismiss",
                        content: HistoryDialog(
                            history[index].amount,
                            history[index].date,
                            history[index].name,
                            history[index].reason,
                            history[index].recAcc,
                            history[index].sendAcc,
                            history[index].type));
                  },
                  child: Container(
                    height: height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          radius: height * 0.035,
                          backgroundColor: history[index].type == "send"
                              ? mainColor
                              : secColor,
                          child: Icon(
                            history[index].type == "send"
                                ? Icons.trending_up
                                : Icons.trending_down,
                            size: height * 0.035,
                          ),
                        ),
                        SizedBox(
                          width: width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: width * 0.4,
                                    child: AutoSizeText(
                                      history[index]
                                          .name
                                          .toString()
                                          .toUpperCase(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: width * 0.035,
                                          fontWeight: FontWeight.w500,
                                          //color: secColor,
                                          letterSpacing: width * 0.004),
                                    ),
                                  ),
                                  AutoSizeText(
                                    DateFormat.yMd()
                                        .format(history[index].date)
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: width * 0.03,
                                        fontWeight: FontWeight.w300,
                                        //color: secColor,
                                        letterSpacing: width * 0.002),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    history[index].type == "send"
                                        ? "+" + history[index].amount + " ETB"
                                        : "-" + history[index].amount + " ETB",
                                    style: TextStyle(
                                        fontSize: width * 0.035,
                                        fontWeight: FontWeight.w500,
                                        //color: secColor,
                                        letterSpacing: width * 0.0022),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ]);
            }));
  }
}
