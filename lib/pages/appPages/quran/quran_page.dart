import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rammisbank/pages/appPages/quran/qurans/surah_page.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:quran/quran.dart' as quran;

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    TabController tabController = TabController(length: 3, vsync: this);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        CupertinoIcons.back,
                        size: width * 0.05,
                      )),
                  AutoSizeText(
                    "Quran",
                    style: GoogleFonts.quicksand(
                        textStyle: TextStyle(
                            color: mainColor, fontSize: width * 0.06)),
                  ),
                  Container()
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Container(
                  height: height * 0.06,
                  decoration: BoxDecoration(
                      color: mainColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30)),
                  child: TabBar(
                    indicator: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.circular(30)),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: const [
                      Tab(
                        text: "Surah",
                      ),
                      Tab(
                        text: "Juz",
                      ),
                      Tab(
                        text: "Page",
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                    _buildSurah(width: width, height: height),
                    _buildJuz(width: width, height: height),
                    _buildPage(width: width, height: height)
                  ]))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurah({
    required double width,
    required double height,
  }) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: quran.totalSurahCount,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Get.to(SurahPage(
                surahNumber: index + 1,
              ));
            },
            leading: Stack(
              children: [
                Image(
                    width: width * 0.06,
                    image: AssetImage("assets/images/frame.png")),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "${index + 1}",
                          style: TextStyle(color: mainColor),
                        ))),
              ],
            ),
            title: AutoSizeText(
              quran.getSurahName(index + 1),
              style: GoogleFonts.quicksand(
                  textStyle:
                      TextStyle(color: mainColor, fontSize: width * 0.03)),
            ),
            subtitle: AutoSizeText(
              "${quran.getPlaceOfRevelation(index + 1).toUpperCase()} - ${quran.getVerseCount(index + 1)} VERSES",
              style: GoogleFonts.quicksand(
                  textStyle:
                      TextStyle(color: Colors.black, fontSize: width * 0.02)),
            ),
            trailing: AutoSizeText(
              quran.getSurahNameArabic(index + 1),
              style: TextStyle(
                  color: mainColor,
                  fontSize: width * 0.035,
                  fontFamily: "Noor"),
            ),
          );
        });
  }

  Widget _buildJuz({
    required double width,
    required double height,
  }) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: quran.totalJuzCount,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: Stack(
              children: [
                Image(
                    width: width * 0.06,
                    image: AssetImage("assets/images/frame.png")),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "${index + 1}",
                          style: TextStyle(color: mainColor),
                        ))),
              ],
            ),
            title: AutoSizeText(
              "Juz ${index + 1}",
              style: GoogleFonts.quicksand(
                  textStyle:
                      TextStyle(color: mainColor, fontSize: width * 0.035)),
            ),
          );
        });
  }

  Widget _buildPage({
    required double width,
    required double height,
  }) {
    return ListView.separated(
        shrinkWrap: true,
        itemCount: quran.totalPagesCount,
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemBuilder: (context, index) {
          return ListTile(
            leading: Stack(
              children: [
                Image(
                    width: width * 0.06,
                    image: AssetImage("assets/images/frame.png")),
                Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          "${index + 1}",
                          style: TextStyle(color: mainColor),
                        ))),
              ],
            ),
            title: AutoSizeText(
              "Page ${index + 1}",
              style: GoogleFonts.quicksand(
                  textStyle:
                      TextStyle(color: mainColor, fontSize: width * 0.035)),
            ),
          );
        });
  }
}
