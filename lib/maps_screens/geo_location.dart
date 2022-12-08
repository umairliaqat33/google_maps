import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps/services/location_services.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyGeoLocation extends StatefulWidget {
  const MyGeoLocation({super.key});

  @override
  State<MyGeoLocation> createState() => _MyGeoLocationState();
}

class _MyGeoLocationState extends State<MyGeoLocation> {
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    Position position = await LocationServices.getLocation();
    setState(() {
      _center = LatLng(position.latitude, position.longitude);
      log(_center.toString());
      final marker = Marker(
        markerId: const MarkerId("My location"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(
          title: "My location",
        ),
      );
      _markers['My Location'] = marker;
      log(_markers.values.toString());
    });
  }

  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};

  LatLng _center = const LatLng(0, 0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    log(_center.toString());
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
        markers: _markers.values.toSet(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => getLocation(),
        tooltip: 'Get current Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
