import 'package:flutter/material.dart';

class Gas extends StatefulWidget {
  const Gas({super.key});

  @override
  State<Gas> createState() => _GasState();
}

class _GasState extends State<Gas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Gas")),
    );
  }
}
