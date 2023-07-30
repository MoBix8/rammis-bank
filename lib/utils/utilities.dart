import 'package:flutter/material.dart';
import 'package:rammisbank/pages/utilityPages/electricity.dart';
import 'package:rammisbank/pages/utilityPages/water.dart';
import 'package:rammisbank/pages/utilityPages/gift.dart';
import 'package:rammisbank/pages/utilityPages/flight.dart';
import 'package:rammisbank/pages/utilityPages/transfer.dart';
import 'package:rammisbank/pages/utilityPages/gas.dart';
import 'package:rammisbank/pages/utilityPages/mobile_card.dart';
import 'package:rammisbank/pages/utilityPages/shop.dart';
import 'package:rammisbank/pages/utilityPages/transport.dart';

class Utilities {
  String? name;
  String? img;
  Widget? page;

  Utilities(this.img, this.name, this.page);

  static List UtilityList() {
    return [
      Utilities("assets/utility/transfer.svg", "Send", const Transfer()),
      Utilities("assets/utility/gas.svg", "Gas", const Gas()),
      Utilities("assets/utility/plane.svg", "Flight", const Flight()),
      Utilities("assets/utility/card.svg", "Card", const MobileCard()),
      Utilities("assets/utility/bolt.svg", "Electric", const Electricity()),
      Utilities("assets/utility/cart.svg", "Shop", const Shop()),
      Utilities("assets/utility/car.svg", "Transport", const Transport()),
      Utilities("assets/utility/gift.svg", "Gift", const Gift()),
      Utilities("assets/utility/water.svg", "Water", const Water()),
    ];
  }
}
