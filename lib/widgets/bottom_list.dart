import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rammisbank/utils/theme_data.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';

class BottomList extends StatefulWidget {
  BottomList({key});

  @override
  State<BottomList> createState() => _BottomListState();
}

class _BottomListState extends State<BottomList> {
  final filterController = TextEditingController();
  final List<String> filters = ['Today', 'This week', 'This month'];

  List name = [
    "Abiy Ahmed",
    "Zumera Bekele",
    "Neima Hassen",
    "Bekele Wondimu",
    "Mohammed Bekele"
  ];

  List type = ["up", "down", "down", "up", "down"];

  List date = [
    "12/11/2022",
    "10/11/2022",
    "08/11/2022",
    "08/11/2022",
    "06/11/2022"
  ];

  List amount = ["200,000", "44,000", "12,000", "10,000", "100"];

  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      selectedValue = filters[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height * 0.01,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  "Transactions",
                  style: TextStyle(
                      fontSize: width * 0.04,
                      fontWeight: FontWeight.w500,
                      //color: secColor,
                      letterSpacing: width * 0.005),
                ),
                ConstrainedBox(
                  // height: height * 0.1,
                  constraints: BoxConstraints(
                    minWidth: width * 0.2,
                    maxWidth: width * 0.25,
                    // maxHeight: height*0
                  ),
                  child: CustomDropdown(
                    fillColor: mainColor,
                    hintText: selectedValue,
                    selectedStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300),
                    borderRadius: BorderRadius.circular(50),
                    items: filters,
                    controller: filterController,
                    onChanged: (val) {
                      setState(() {
                        selectedValue = val;
                      });
                    },
                    fieldSuffixIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {
                return index == 0
                    ? SizedBox(
                        height: height * 0.01,
                      )
                    : ListTile(
                        tileColor: Colors.grey[200],
                        leading: CircleAvatar(
                          radius: height * 0.035,
                          backgroundColor:
                              type[index] == "up" ? mainColor : secColor,
                          child: Icon(
                            type[index] == "up"
                                ? Icons.trending_up
                                : Icons.trending_down,
                            size: height * 0.035,
                          ),
                        ),
                        title: AutoSizeText(
                          name[index].toString().toUpperCase(),
                          style: TextStyle(
                              fontSize: width * 0.04,
                              fontWeight: FontWeight.w500,
                              //color: secColor,
                              letterSpacing: width * 0.002),
                        ),
                        subtitle: AutoSizeText(
                          date[index],
                          style: TextStyle(
                              fontSize: width * 0.03,
                              fontWeight: FontWeight.w300,
                              //color: secColor,
                              letterSpacing: width * 0.002),
                        ),
                        trailing: AutoSizeText(
                          type[index] == "up"
                              ? "+" + amount[index] + " ETB"
                              : "-" + amount[index] + " ETB",
                          style: TextStyle(
                              fontSize: width * 0.045,
                              fontWeight: FontWeight.w500,
                              //color: secColor,
                              letterSpacing: width * 0.0022),
                        ),
                      );
              }),
          SizedBox(
            height: height * 0.01,
          ),
        ],
      ),
    );
  }
}
