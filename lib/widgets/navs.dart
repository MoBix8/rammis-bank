import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:rammisbank/utils/utilities.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Navs extends StatefulWidget {
  final ScrollController? scrollController;

  Navs({key, this.scrollController});

  @override
  State<Navs> createState() => _NavsState();
}

class _NavsState extends State<Navs> {
  TimerController timerController = Get.put(TimerController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.15,
      width: width,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: Utilities.UtilityList().length,
          itemBuilder: (context, index) {
            final utility = Utilities.UtilityList();
            return Row(
              children: [
                SizedBox(
                  width: width * 0.02,
                ),
                Column(
                  verticalDirection: index.isOdd
                      ? VerticalDirection.down
                      : VerticalDirection.up,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Align(
                      alignment: index.isOdd
                          ? Alignment.topCenter
                          : Alignment.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          //timerController.timer!.cancel();
                          timerController.seconds = timerController.MaxSecond;
                          Get.to(utility[index].page);
                        },
                        child: CircleAvatar(
                          radius: height * 0.042,
                          backgroundColor: mainColor,
                          child: CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              utility[index].img,
                              color: mainColor,
                              height: height * 0.04,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                        alignment: index.isEven
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        child: AutoSizeText(
                          utility[index].name,
                          style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w300,
                              color: mainColor,
                              letterSpacing: width * 0.005),
                        )),
                  ],
                ),
                SizedBox(
                  width: width * 0.02,
                )
              ],
            );
          }),
    );
  }
}
