import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:rammisbank/pages/Islamic.dart';
// import '../pages/apps/adhan/adhan.dart';

class AdhanPermissionPage extends StatefulWidget {
  const AdhanPermissionPage({Key? key}) : super(key: key);

  @override
  _AdhanPermissionPageState createState() => _AdhanPermissionPageState();
}

class _AdhanPermissionPageState extends State<AdhanPermissionPage> {
  Location location = Location();

  @override
  void initState() {
    super.initState();
  }

  Future<PermissionStatus> checkPermission() async {
    return await location.hasPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PermissionStatus>(
          future: checkPermission(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data == PermissionStatus.granted) {
                return Islamic();
              } else {
                return Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        await location.requestPermission();
                        setState(() {});
                      },
                      child: Text("Need Permission")),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
