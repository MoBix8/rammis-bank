import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:rammisbank/pages/login_page.dart';
import 'package:rammisbank/widgets/navbar.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init();
  tz.initializeTimeZones();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  TimerController timerController = Get.put(TimerController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) return;

    final isBackground = state == AppLifecycleState.paused;

    final isForeground = state == AppLifecycleState.resumed;

    var route = ModalRoute.of(context);
    if (isBackground || isForeground) {
      //Get.offAll(Login());
      //timerController.stopTimer();
      if (route!.settings.name == "login") {
        timerController.setLocked(false);
      } else {
        timerController.setLocked(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rammis Bank',
      routes: {
        "login": (context) => LoginPage(),
        "index": (context) => NavBar()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
