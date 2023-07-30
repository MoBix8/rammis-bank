import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran/quran.dart' as quran;
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rammisbank/utils/theme_data.dart';

class SurahPage extends StatefulWidget {
  final int? surahNumber;

  const SurahPage({super.key, required this.surahNumber});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  // final translator = GoogleTranslator();
  List _amh = [];
  final storage = GetStorage();
  late int selectedIndex;

  bool loading = false;
  double progress = 0.0;

  late String selectedValue;
  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
        value: "oro",
        child: Text("Afan Oromo"),
      ),
      const DropdownMenuItem(
        value: "afr",
        child: Text("Afar"),
      ),
      const DropdownMenuItem(
        value: "amh",
        child: Text("Amharic"),
      ),
      const DropdownMenuItem(
        value: "som",
        child: Text("Somali"),
      ),
    ];
    return menuItems;
  }

  List<dynamic> getChapterData(int chapter) {
    return _amh.where((item) => item["chapter"] == chapter).toList();
  }

  Future<void> readAmh() async {
    final String response =
        await rootBundle.loadString('assets/json/${selectedValue}.json');
    final data = await json.decode(response);

    setState(() {
      _amh = data["quran"];
      _amh.where((element) => element['chapter'] == 2).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage.read("lang") == null ? storage.write("lang", "oro") : null;
    setState(() {
      selectedValue = storage.read("lang");
    });
    readAmh();
  }

  // late SimpleDownloader _downloader;

  double _progress = 0.0;
  int _offset = 0;
  int _total = 0;

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: _height * 0.02),
      child: FutureBuilder(
          future: readAmh(),
          builder: (context, snapshot) {
            return ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // final translation = translator
                  //     .translate(
                  //         quran.getVerseTranslation(
                  //             widget.surahNumber!, index + 1),
                  //         from: 'en',
                  //         to: 'am')
                  //     .toString();
                  final amhVerse = getChapterData(widget.surahNumber!)[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: _width * 0.02),
                    child: Container(
                      child: Column(
                        children: [
                          index == 0
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: _width * 0.02,
                                      vertical: _height * 0.02),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: Icon(
                                                CupertinoIcons.back,
                                                size: _width * 0.05,
                                              )),
                                          AutoSizeText(
                                            "Quran",
                                            style: GoogleFonts.quicksand(
                                                textStyle: TextStyle(
                                                    color: mainColor,
                                                    fontSize: _width * 0.06)),
                                          ),
                                          DropdownButton(
                                              value: selectedValue,
                                              items: dropdownItems,
                                              onChanged: ((value) {
                                                setState(() {
                                                  selectedValue = value!;
                                                  storage.write("lang", value);
                                                });
                                              })),
                                        ],
                                      ),
                                      SizedBox(
                                        height: _height * 0.02,
                                      ),
                                      Container(
                                        height: _height * 0.4,
                                        width: _width,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                opacity: 0.3,
                                                alignment:
                                                    Alignment.bottomCenter,
                                                image: AssetImage(
                                                    "assets/images/quran2.png")),
                                            gradient: const LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Color.fromARGB(
                                                      255, 26, 61, 119),
                                                  Color.fromARGB(
                                                      255, 15, 46, 95),
                                                  Color.fromARGB(
                                                      255, 6, 30, 69),
                                                  Color.fromARGB(
                                                      255, 2, 30, 74),
                                                ])),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              quran.getSurahName(
                                                  widget.surahNumber!),
                                              style: TextStyle(
                                                  fontSize: _width * 0.06,
                                                  color: Colors.white,
                                                  letterSpacing: _width * 0.002,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${quran.getSurahNameEnglish(widget.surahNumber!)}",
                                              style: TextStyle(
                                                  fontSize: _width * 0.04,
                                                  color: Colors.white,
                                                  letterSpacing: _width * 0.001,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            SizedBox(
                                                width: _width * 0.6,
                                                child: Divider(
                                                  thickness: _height * 0.002,
                                                  height: _height * 0.05,
                                                  color: Colors.white,
                                                )),
                                            Text(
                                              "${quran.getPlaceOfRevelation(widget.surahNumber!)} | ${quran.getVerseCount(widget.surahNumber!)} Verses",
                                              style: TextStyle(
                                                  fontSize: _width * 0.03,
                                                  color: Colors.white,
                                                  letterSpacing:
                                                      _width * 0.0005,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(
                                              height: _height * 0.02,
                                            ),
                                            Image(
                                              image: AssetImage(
                                                  "assets/images/bism.png"),
                                              width: _width * 0.6,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: _height * 0.02,
                                ),
                          Container(
                            width: _width,
                            height: _height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color.fromARGB(255, 26, 61, 119),
                                      Color.fromARGB(255, 15, 46, 95),
                                      Color.fromARGB(255, 6, 30, 69),
                                      Color.fromARGB(255, 2, 30, 74),
                                    ])),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: _width * 0.02),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    radius: _height * 0.02,
                                    backgroundColor: Colors.white54,
                                    child: Text(
                                      (index + 1).toString(),
                                      style: TextStyle(
                                          color: mainColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.share),
                                        color: Colors.white54,
                                      ),
                                      IconButton(
                                        onPressed: () async {},
                                        icon: storage.read(
                                                    "surah ${widget.surahNumber} ayah ${index + 1}") ==
                                                null
                                            ? Icon(Icons.download)
                                            : Icon(CupertinoIcons.play),
                                        color: Colors.white54,
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.bookmark_border),
                                        color: Colors.white54,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              quran.getVerse(
                                widget.surahNumber!,
                                index + 1,
                              ),
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: _height * 0.025),
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              amhVerse['text'].toString(),
                              // _amh[index]['text'].toString(),
                              style: TextStyle(fontSize: _height * 0.02),
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: quran.getVerseCount(widget.surahNumber!));
          }),
    ));
  }
}

//                             future: translator.translate(
//                                 quran.getVerseTranslation(
//                                     widget.surahNumber!, index + 1),
//                                 from: 'en',
//                                 to: 'am'),
//                             builder: (context, snapshot) {
//                               return Align(
//                                 alignment: Alignment.centerLeft,
//                                 child: Text(
//                                   snapshot.data.toString(),
//                                   style:
//                                       TextStyle(fontSize: _height * 0.02),
//                                 ),
//                               );
//                             }),