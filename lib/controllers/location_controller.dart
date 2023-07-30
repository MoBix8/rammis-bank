import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocationController extends GetxController {
  Position? currentPosition;
  var isLoading = false.obs;
  var timeNow = DateTime.now().obs;
  final storage = GetStorage();

  String? currentLocation;
  double? latitude;
  double? longitude;
  String? prayer;

  Future<Position> getPosition() async {
    LocationPermission? permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission are denied");
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> getAddressFromLatLng(long, lat) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      Placemark place = placemarks[0];

      currentLocation = "${place.locality}, ${place.country}";

      storage.write("location", currentLocation);
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoading(true);
      update();
      currentPosition = await getPosition();
      getAddressFromLatLng(
          currentPosition!.longitude, currentPosition!.latitude);
      storage.write("lat", currentPosition!.latitude);
      storage.write("long", currentPosition!.longitude);
      storage.write("heading", currentPosition!.heading);

      latitude = currentPosition!.latitude;
      longitude = currentPosition!.longitude;

      isLoading(false);
      update();
    } catch (e) {
      print(e);
    }
  }
}
