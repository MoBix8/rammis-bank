import 'package:flutter/material.dart';

class Flight extends StatefulWidget {
  const Flight({super.key});

  @override
  State<Flight> createState() => _TransferState();
}

class _TransferState extends State<Flight> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Flight")),
    );
  }
}
