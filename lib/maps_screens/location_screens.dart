import 'package:flutter/material.dart';
import 'package:google_maps/maps_screens/geo_location.dart';
import 'package:google_maps/maps_screens/get_locations.dart';

class LocationScreens extends StatelessWidget {
  const LocationScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Location of google offices via https',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: height * 0.4,
          child: const GetLocation(),
        ),
        const Text(
          'My current location',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: height * 0.38,
          child: const MyGeoLocation(),
        ),
      ],
    );
  }
}
