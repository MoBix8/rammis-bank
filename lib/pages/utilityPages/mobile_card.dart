import 'package:flutter/material.dart';

class MobileCard extends StatefulWidget {
  const MobileCard({super.key});

  @override
  State<MobileCard> createState() => _MobileCardState();
}

class _MobileCardState extends State<MobileCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("MobileCard")),
    );
  }
}
