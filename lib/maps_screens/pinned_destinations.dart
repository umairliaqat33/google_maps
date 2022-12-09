import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class PinnedDestinations extends StatefulWidget {
  const PinnedDestinations({Key? key}) : super(key: key);

  @override
  State<PinnedDestinations> createState() => _PinnedDestinationsState();
}

class _PinnedDestinationsState extends State<PinnedDestinations> {
  final TextEditingController _destinationLatController =
      TextEditingController();
  final TextEditingController _destinationLonController =
      TextEditingController();
  final TextEditingController _beginningLatController = TextEditingController();
  final TextEditingController _beginningLonController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late GoogleMapController mapController;
  final Map<String, Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  late PolylinePoints polylinePoints;
  final Set<LatLng> latLng = {};
  final Set<LatLng> polyLineCoordinates = {};

  LatLng _center = const LatLng(
    31.581785,
    74.290329,
  );

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Destination Coordinates",
                style: TextStyle(
                  backgroundColor: Colors.green,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your destination",
                ),
                keyboardType: TextInputType.number,
                controller: _destinationLatController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter destination coordinates";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your destination's latitude",
                ),
                keyboardType: TextInputType.number,
                controller: _destinationLonController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter destination coordinates";
                  }
                  return null;
                },
              ),
              const Text(
                "Beginning Coordinates",
                style: TextStyle(
                  backgroundColor: Colors.green,
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your beginning latitude",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter beginning coordinates";
                  }
                  return null;
                },
                controller: _beginningLatController,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Enter your beginning longitude",
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter beginning coordinates";
                  }
                  return null;
                },
                controller: _beginningLonController,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15,
                  ),
                  polylines: _polyline,
                  markers: _markers.values.toSet(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => showRoute(),
        child: const Icon(Icons.search),
      ),
    );
  }

  void setMarkers(String markerId, double lat, double lon) {
    setState(() {
      final marker = Marker(
        markerId: MarkerId(markerId),
        position: LatLng(
          lat,
          lon,
        ),
        infoWindow: InfoWindow(
          title: markerId,
        ),
      );
      _markers[markerId] = marker;
    });
  }

  Future<void> showRoute() async {
    if (_formKey.currentState!.validate()) {
      _markers.clear();
      setMarkers(
        "My Destination",
        double.parse(_destinationLatController.text),
        double.parse(_destinationLonController.text),
      );
      setMarkers(
        "My Location",
        double.parse(_beginningLatController.text),
        double.parse(_beginningLonController.text),
      );
      _center = LatLng(double.parse(_destinationLatController.text),
          double.parse(_destinationLonController.text));
    }
    latLng.add(
      LatLng(
        double.parse(_destinationLatController.text),
        double.parse(_destinationLonController.text),
      ),
    );

    latLng.add(
      LatLng(
        double.parse(_beginningLatController.text),
        double.parse(_beginningLonController.text),
      ),
    );
    _setPolyLine();
    setState(() {});
  }

  void _setPolyLine() async {
    bool locationPermission = await Geolocator.isLocationServiceEnabled();
    log("came in polyline functions");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyBG-VcZaKVIimxg6Gnm_vqUV5uY50u87RA',
      PointLatLng(
        double.parse(_beginningLatController.text),
        double.parse(_beginningLonController.text),
      ),
      PointLatLng(
        double.parse(_destinationLatController.text),
        double.parse(_destinationLonController.text),
      ),
      travelMode: TravelMode.driving,
    );
    if (result.status == 'OK') {
      for (var pointLatLng in result.points) {
        polyLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
      setState(() {
        _polyline.add(
          Polyline(
            polylineId: const PolylineId('value'),
            visible: true,
            width: 10,
            color: Colors.blue,
            points: polyLineCoordinates.toList(),
          ),
        );
      });
    }
    log(result.status.toString());
    log(result.errorMessage.toString());
    log(result.points.toString());
    log(locationPermission.toString());
  }
}
//31.581785
//74.290329
//31.5107366
//74.3397132
