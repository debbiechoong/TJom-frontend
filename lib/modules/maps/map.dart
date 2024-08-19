import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/providers/interest_provider.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng initialPosition = const LatLng(33.499621, 126.531188);

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  void _initializeMap() {
    final interestProvider =
        Provider.of<InterestProvider>(context, listen: false);
    interestProvider.fetchUserInterests().then((_) {
      _setMarkers(interestProvider.getInterests());
      if (markers.isNotEmpty) {
        setState(() {
          initialPosition = markers.first.position;
        });
      }
    });
  }

  void _setMarkers(List<InterestDestination> interests) {
    markers.clear();
    for (var interest in interests) {
      if (interest.llmDescription != null &&
          interest.llmDescription!.isNotEmpty) {
        markers.add(
          Marker(
            markerId: MarkerId(interest.id),
            position: LatLng(interest.lat, interest.long),
            infoWindow: InfoWindow(
              title: interest.name,
              onTap: () => _showInterestDetails(interest),
            ),
          ),
        );
      }
    }
  }

  void _showInterestDetails(InterestDestination interest) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                interest.imageUrl.isNotEmpty
                    ? interest.imageUrl[0]
                    : 'assets/images/image1.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/image1.jpg',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    interest.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(interest.address),
                  const SizedBox(height: 8),
                  if (interest.llmDescription != null)
                    Text(interest.llmDescription!),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => mapController = controller,
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 14.0,
            ),
            markers: markers,
            // onTap: _handleMapTap,
          ),
          Positioned(
            top: 40,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  // void _handleMapTap(LatLng position) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       TextEditingController descriptionController = TextEditingController();
  //       return AlertDialog(
  //         title: const Text('Add a new location'),
  //         content: TextField(
  //           controller: descriptionController,
  //           decoration: const InputDecoration(hintText: 'Enter a description'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               _addNewInterest(position, descriptionController.text);
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Add'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // void _addNewInterest(LatLng position, String description) async {
  //   final interestProvider =
  //       Provider.of<InterestProvider>(context, listen: false);
  //   final newInterest = InterestDestination(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     name: 'New Location',
  //     description: description,
  //     imageUrl: [],
  //     address: '',
  //     lat: position.latitude,
  //     long: position.longitude,
  //   );

  //   setState(() {
  //     interestProvider.interests!.add(newInterest);
  //     markers.add(
  //       Marker(
  //         markerId: MarkerId(newInterest.id),
  //         position: LatLng(newInterest.lat, newInterest.long),
  //         infoWindow: InfoWindow(
  //           title: newInterest.name,
  //           onTap: () => _showInterestDetails(newInterest),
  //         ),
  //       ),
  //     );
  //   });

  //   await interestProvider.saveInterestsToFirebase();
  // }
