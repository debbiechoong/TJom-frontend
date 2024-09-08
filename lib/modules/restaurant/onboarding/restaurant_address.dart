import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jejom/modules/restaurant/onboarding/restaurant_success.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:provider/provider.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 16),
              Text(
                "Restaurant Address",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text("Address", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: "Type your address here",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.location_searching_rounded),
                    onPressed: () {
                      final address = onBoardingProvider.address;
                      if (address.isNotEmpty) {
                        _locateAddress(address);
                      }
                    },
                  ),
                  helperText:
                      "After inputting your address, press the locate button",
                ),
                onChanged: (value) => onBoardingProvider.setAddress(value),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
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
                    : const Center(
                        child: Text('Enter address to locate on map.'),
                      ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Spacer(),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primaryContainer),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_currentLocation != null) {
                              onBoardingProvider
                                  .setLatitude(_currentLocation!.latitude);
                              onBoardingProvider
                                  .setLongitude(_currentLocation!.longitude);

                              // Upload all data
                              onBoardingProvider.uploadToDB();

                              // Proceed to the next screen
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RestaurantOnboardingSuccess(),
                                ),
                              );
                            }
                          },
                    child: _isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Loading...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ],
                          )
                        : Text("Next",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
