import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:rammisbank/widgets/main_card.dart';
import 'package:unicons/unicons.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:rammisbank/widgets/navs.dart';
import 'package:rammisbank/widgets/bottom_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TimerController _timerController = Get.put(TimerController());

  ScrollController _scrollController = ScrollController();

  List img = [
    "assets/cards/cash1.png",
    "assets/cards/cash2.png",
    "assets/cards/cash3.png"
  ];
  List balance = ["107,891.56", "20,542.89", "12,981.43"];
  List acc = ["0006662210301", "0006667121332", "0006661290974"];
  List color = [mainColor, secColor, thrColor];
  List opac = [0.4, 0.4, 0.9];
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
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
            height: height * 0.35,
            width: width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(50))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: height * 0.02,
                ),
                SizedBox(
                  height: height * 0.31,
                  width: width * 0.95,
                  child: Swiper(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return MainCard(
                        img: img[index],
                        balance: balance[index],
                        acc: acc[index],
                        color: color[index],
                        opac: opac[index],
                      );
                    },
                    layout: SwiperLayout.STACK,
                    allowImplicitScrolling: true,
                    loop: false,
                    itemWidth: width * 0.95,
                    itemHeight: height * 0.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Navs(
            scrollController: _scrollController,
          ),
          SizedBox(
            height: height * 0.01,
          ),
          Container(
            //height: height * 0.25,
            width: width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    //topLeft: Radius.circular(-30),
                    topRight: Radius.circular(30))),
            child: BottomList(),
          )
        ]),
      ),
    );
  }
}
