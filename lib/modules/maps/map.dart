import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  static const LatLng _jeju = LatLng(33.489011, 126.498302);
  LatLng? _currentLocation;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocation();
    fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar:
          true, // This will make the Scaffold content extend behind the AppBar
      backgroundColor: Colors.transparent, // Transparent background
      body: SafeArea(
        child: Stack(
          // Use Stack to layer the back button over the map
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _jeju, zoom: 13),
              markers: _markers,
              onTap: _handleTap, // Add onTap functionality
            ),
            Positioned(
              // Position the back button on top of the map
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // White background for the circle
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black, // Black icon for contrast
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permission;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permission = await _locationController.hasPermission();
    if (_permission == PermissionStatus.denied) {
      _permission = await _locationController.requestPermission();
      if (_permission != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  Future<void> fetchLocations() async {
    // Soli hard code for now
    String response = '''
    [
      {"latitude": 33.499011, "longitude": 126.498302, "description": "GM"},
      {"latitude": 33.501010, "longitude": 126.491020, "description": "YX"},
      {"latitude": 33.493000, "longitude": 126.489001, "description": "Debbie"}
    ]
    ''';

    List<dynamic> locations = jsonDecode(response);

    Set<Marker> fetchedMarkers = locations.map((location) {
      return Marker(
        markerId: MarkerId(location['description']),
        position: LatLng(location['latitude'], location['longitude']),
        infoWindow: InfoWindow(
          title: location['description'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    }).toSet();

    setState(() {
      _markers.addAll(fetchedMarkers);
    });
  }

  void _handleTap(LatLng tappedPoint) async {
    String? description = await _showPinDialog();
    if (description != null && description.isNotEmpty) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(tappedPoint.toString()),
            position: tappedPoint,
            infoWindow: InfoWindow(
              title: description,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      });
    }
  }

  Future<String?> _showPinDialog() async {
    String? description;
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pin Description"),
          content: TextField(
            onChanged: (value) {
              description = value;
            },
            decoration: const InputDecoration(
              hintText: "Tell us about the location!",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(description);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
