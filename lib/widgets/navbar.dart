import 'package:flutter/material.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:get/get.dart';
import 'package:rammisbank/pages/home.dart';
import 'package:unicons/unicons.dart';

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
    const Home(),
    const Home(),
    const Home(),

    //const Profile()
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: _pages.elementAt(timerController.Index),
      bottomNavigationBar: Container(
        child: BottomNavigationBar(items: [
          BottomNavigationBarItem(label: "Home", icon: Icon(UniconsLine.home, color: timerController.Index == 0 ? ,)),
          BottomNavigationBarItem(label: "Home", icon: Icon(UniconsLine.home, color: timerController.Index == 0 ? ,)),
          BottomNavigationBarItem(label: "Home", icon: Icon(UniconsLine.home, color: timerController.Index == 0 ? ,)),
          BottomNavigationBarItem(label: "Home", icon: Icon(UniconsLine.home, color: timerController.Index == 0 ? ,)),
        ]),
      ),
    );
  }
}
