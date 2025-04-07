import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jejom/modules/restaurant/onboarding/restaurant_success.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class RestaurantAddress extends StatefulWidget {
  const RestaurantAddress({super.key});

  @override
  State<RestaurantAddress> createState() => _RestaurantAddressState();
}

class _RestaurantAddressState extends State<RestaurantAddress> {
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  Marker? _selectedMarker;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedMarker = null;
  }

  Future<void> _locateAddress(String address) async {
    try {
      // address = "1866, kampung sungai rambai, 14000 bukit mertajam";
      FocusManager.instance.primaryFocus?.unfocus();
      // Use Geolocator to get latitude and longitude based on address input
      List<Location> locations = await locationFromAddress(address);
      // print('Locations: $locations');
      if (locations.isNotEmpty) {
        final place = locations.first;
        final position = LatLng(place.latitude, place.longitude);

        setState(() {
          _currentLocation = position;
          _selectedMarker = Marker(
            markerId: const MarkerId('selected-location'),
            position: position,
            draggable: true,
            onDragEnd: (LatLng newPosition) {
              setState(() {
                _currentLocation = newPosition;
              });
            },
          );
        });

        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );
      }
    } catch (e) {
      // Handle error
      print("Error locating address: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider =
        Provider.of<RestaurantOnboardingProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),
          
          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Restaurant Address",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Let customers find your restaurant",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Address input
                    buildInputLabel("Address"),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.location_on, color: Colors.black54),
                              border: InputBorder.none,
                              hintText: "Type your address here",
                              hintStyle: TextStyle(color: Colors.black54),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.location_searching_rounded, color: Colors.black54),
                                onPressed: () {
                                  final address = onBoardingProvider.address;
                                  if (address.isNotEmpty) {
                                    _locateAddress(address);
                                  }
                                },
                              ),
                            ),
                            style: TextStyle(color: Colors.black87),
                            onChanged: (value) => onBoardingProvider.setAddress(value),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    Text(
                      "After inputting your address, press the locate button",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Map container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.35,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: _currentLocation != null
                                ? GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: _currentLocation!,
                                      zoom: 14,
                                    ),
                                    markers:
                                        _selectedMarker != null ? {_selectedMarker!} : {},
                                    onMapCreated: (controller) {
                                      _mapController = controller;
                                    },
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.map_outlined,
                                          size: 60,
                                          color: Colors.black54,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          "Enter address to locate on map",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Next Button
                    Center(
                      child: GestureDetector(
                        onTap: _isLoading || _currentLocation == null
                          ? null
                          : () {
                              setState(() {
                                _isLoading = true;
                              });
                              
                              onBoardingProvider.setLatitude(_currentLocation!.latitude);
                              onBoardingProvider.setLongitude(_currentLocation!.longitude);
                              
                              // Upload all data
                              onBoardingProvider.uploadToDB();
                              
                              // Proceed to the next screen
                              setState(() {
                                _isLoading = false;
                              });
                              
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RestaurantOnboardingSuccess(),
                                ),
                              );
                            },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                          decoration: BoxDecoration(
                            color: _isLoading || _currentLocation == null ? Colors.grey : Colors.black87,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Saving...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildInputLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }
}
