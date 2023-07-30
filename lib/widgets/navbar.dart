import 'package:flutter/material.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:get/get.dart';
import 'package:rammisbank/pages/Islamic.dart';
import 'package:rammisbank/pages/Profile.dart';
import 'package:rammisbank/pages/history.dart';
import 'package:rammisbank/pages/home.dart';
import 'package:rammisbank/pages/login_page.dart';
import 'package:unicons/unicons.dart';
import "package:rammisbank/utils/theme_data.dart";

class NavBar extends StatefulWidget {
  int? index = 0;
  NavBar({key, this.index});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  TimerController timerController = Get.put(TimerController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerController.startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timerController.timer!.cancel();
    super.dispose();
  }

  final _pages = [
    const Home(),
    const History(),
    const Islamic(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Obx(() {
      return timerController.Locked
          ? LoginPage()
          : Scaffold(
              body: Listener(
                onPointerMove: (move) {
                  setState(() {
                    timerController.seconds = timerController.MaxSecond;
                  });
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      timerController.seconds = timerController.MaxSecond;
                    });
                  },
                  onTapCancel: () {},
                  child: _pages.elementAt(timerController.Index),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // _onItemTapped(4);
                },
                child: Icon(UniconsLine.qrcode_scan),
                backgroundColor: mainColor,
              ),
              bottomNavigationBar: Container(
                child: BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    unselectedItemColor: Colors.grey,
                    selectedItemColor: mainColor,
                    elevation: 0.1,
                    type: BottomNavigationBarType.fixed,
                    backgroundColor: Colors.white,
                    currentIndex: timerController.Index,
                    onTap: _onItemTapped,
                    items: [
                      BottomNavigationBarItem(
                          label: "Home",
                          icon: Icon(
                            UniconsLine.home,
                            color: timerController.Index == 0
                                ? mainColor
                                : Colors.grey,
                          )),
                      BottomNavigationBarItem(
                          label: "History",
                          icon: Icon(
                            UniconsLine.transaction,
                            color: timerController.Index == 1
                                ? mainColor
                                : Colors.grey,
                          )),
                      BottomNavigationBarItem(
                          label: "Islamic",
                          icon: Icon(
                            UniconsLine.book_open,
                            color: timerController.Index == 2
                                ? mainColor
                                : Colors.grey,
                          )),
                      BottomNavigationBarItem(
                          label: "User",
                          icon: Icon(
                            UniconsLine.user,
                            color: timerController.Index == 3
                                ? mainColor
                                : Colors.grey,
                          )),
                    ]),
              ),
            );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      timerController.setIndex(index);
      timerController.seconds = timerController.MaxSecond;
    });
  }
}
