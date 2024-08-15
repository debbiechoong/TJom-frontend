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

  // Store all markers including those from the backend
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    getLocation();
    fetchBackendLocations(); // Fetch locations from the backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: _jeju, zoom: 13),
              markers: _markers,
              onTap: _handleTap, // Add onTap functionality
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

  Future<void> fetchBackendLocations() async {
    // Soli hard code for now
    String response = '''
    [
      {"latitude": 33.499011, "longitude": 126.498302, "description": "GM"},
      {"latitude": 33.501010, "longitude": 126.491020, "description": "YX"},
      {"latitude": 33.493000, "longitude": 126.489001, "description": "Debbie"}
    ]
    ''';

    // Parse the JSON response
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
              hintText: "Enter a short description",
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
