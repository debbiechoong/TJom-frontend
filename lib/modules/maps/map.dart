import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/modules/maps/destination_sheet.dart';
import 'package:jejom/providers/interest_provider.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Location _locationController = Location();

  final LatLng _jeju = const LatLng(33.489011, 126.498302);
  LatLng? _currentLocation;

  final Set<Marker> _markers = {};

  //bottom sheet
  final DraggableScrollableController _destinationSheetController =
      DraggableScrollableController();
  final GlobalKey _destinationSheetKey = GlobalKey();
  bool isSheetShow = false;
  InterestDestination? pickedDestination;

  @override
  void initState() {
    super.initState();
    // getLocation();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLocations();
  }

  @override
  void dispose() {
    // _locationController.onLocationChanged
    //     .listen((_) {})
    //     .cancel(); 
    super.dispose();
  }

  void openSheet() {
    if (!isSheetShow) {
      _destinationSheetController.animateTo(0.5,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    isSheetShow = true;
  }

  void closeSheet() {
    if (isSheetShow) {
      _destinationSheetController.animateTo(0.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
    isSheetShow = false;
  }

  @override
  Widget build(BuildContext context) {
    final interestProvider = Provider.of<InterestProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar:
          true, // This will make the Scaffold content extend behind the AppBar
      backgroundColor: Colors.transparent, // Transparent background
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _jeju, zoom: 13),
            markers: _markers,
            onTap: _handleTap,
          ),
          AnimatedOpacity(
            opacity: !isSheetShow ? 0 : 1,
            duration: const Duration(milliseconds: 300),
            child: DestinationBottomSheet(
              destinationSheetKey: _destinationSheetKey,
              destinationSheetController: _destinationSheetController,
              openSheet: openSheet,
              closeSheet: closeSheet,
              pickedDestination: pickedDestination,
            ),
          ),
          Positioned(
            top: 80,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onBackground,
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
    );
  }

  Future<void> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permission;

    serviceEnabled = await _locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permission = await _locationController.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await _locationController.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (!mounted) return; // Check if widget is still mounted

      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentLocation =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
        });
      }
    });
  }

  void fetchLocations() async {
    final interestProvider = Provider.of<InterestProvider>(context);
    // print("Where are you ${interestProvider.getInterests()}");

    Set<Marker> fetchedMarkers = interestProvider.getInterests().map((des) {
      return Marker(
        markerId: MarkerId(des.id),
        position: LatLng(des.lat, des.long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          setState(() {
            pickedDestination = des;
          });
          openSheet();
        },
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
