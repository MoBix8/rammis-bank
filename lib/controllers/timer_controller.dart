import 'dart:async';

import 'package:get/get.dart';

class TimerController extends GetxController {
  final _locked = false.obs;
  get Locked => _locked.value;
  set Locked(value) => _locked.value = value;

  final _selectedIndex = 0.obs;
  get Index => _selectedIndex.value;
  set Index(value) => _selectedIndex.value = value;

  final _maxSeconds = 300.obs;
  get MaxSecond => _maxSeconds.value;

  setLocked(bool value) {
    Locked = value;
    update();
  }

  setIndex(int value) {
    Index = value;
    update();
  }

  static const maxSeconds = 300;
  int seconds = maxSeconds;

  Timer? timer;

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
        print(seconds);
      } else {
        stopTimer(reset: false);
        setLocked(true);
        //Get.offAll(Login());
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;
}
