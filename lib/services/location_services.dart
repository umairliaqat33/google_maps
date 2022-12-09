import 'package:geolocator/geolocator.dart';
import 'package:google_maps/model/locations.dart';

class LocationServices {
  static Future<Position> getLocation() async {
    bool locationPermission;
    LocationPermission permission;

    locationPermission = await Geolocator.isLocationServiceEnabled();
    if (!locationPermission) {
      return Future.error("Location Permission not allowed");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  static Future<LatLng> getCenter() async {
    Position position = await getLocation();
    double lat = position.latitude;
    double lon = position.longitude;
    return LatLng(lat: lat, lng: lon);
  }
}
