import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:rammisbank/controllers/timer_controller.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:rammisbank/widgets/navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controller = TextEditingController();
  final TimerController _timerController = Get.put(TimerController());

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                // colorFilter: ColorFilter.mode(
                //     Colors.black.withOpacity(0.3), BlendMode.dstATop),
                fit: BoxFit.fitHeight)),
        child: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: width,
                      child: Image.asset(
                        "assets/images/rammis.png",
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      cursorColor: mainColor,
                      decoration: InputDecoration(
                          hintText: "PIN CODE",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: mainColor))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your PIN";
                        } else if (value != "1234" && value != null) {
                          return "The PIN you entered is Incorrect. Please try again";
                        }
                      },
                    ),
                    SizedBox(
                      height: height * 0.04,
                    ),
                    Obx(() {
                      return MaterialButton(
                        height: height * 0.06,
                        minWidth: width,
                        color: mainColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _timerController.Locked
                                ? ({
                                    _timerController.setLocked(false),
                                    _timerController.startTimer()
                                  })
                                : Get.offAll(NavBar());
                          }
                        },
                        child: Text(
                          _timerController.Locked ? "UNLOCK" : "LOGIN",
                          style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: width * 0.009),
                        ),
                      );
                    })
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
