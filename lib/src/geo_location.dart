import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGeoLocation extends StatefulWidget {
  const MyGeoLocation({super.key});

  @override
  State<MyGeoLocation> createState() => _MyGeoLocationState();
}

class _MyGeoLocationState extends State<MyGeoLocation> {
  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    getLocation();
    mapController = controller;
  }

  Future<void> getLocation() async {
    _markers.clear();
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
    setState(() {
      final marker = Marker(
        markerId: const MarkerId("My location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: "My location",
        ),
      );
      _markers['My Location'] = marker;
    });
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => getLocation(),
        tooltip: 'Get current Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
