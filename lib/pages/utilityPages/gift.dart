import 'package:flutter/material.dart';

class Gift extends StatefulWidget {
  const Gift({super.key});

  @override
  State<Gift> createState() => _GiftState();
}

class _GiftState extends State<Gift> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Gift")),
    );
  }
}
