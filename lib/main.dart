import 'package:flutter/material.dart';

import 'package:google_maps/maps_screens/location_screens.dart';
import 'package:google_maps/maps_screens/pinned_destinations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Map demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> btmItems = <Widget>[
    const LocationScreens(),
    const PinnedDestinations()
  ];
  int _selectedIndex = 0;

  _onBTMTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.my_location),
            label: "Location Screens",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: "Pinned Locations",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onBTMTap,
      ),
      body: Center(
        child: btmItems.elementAt(_selectedIndex),
      ),
    );
  }
}
