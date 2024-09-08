import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/providers/user/interest_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
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
            onTap: () => _showInterestDetails(interest),
          ),
        );
      }
    }
  }

  void _showInterestDetails(InterestDestination interest) {
    showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 64,
                height: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    interest.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FilledButton(
                onPressed: () => launchGoogleMaps(interest.lat, interest.long),
                child: const Text('Navigate')),
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(interest.address,
                          style: Theme.of(context).textTheme.labelLarge),
                      const SizedBox(height: 8),
                      if (interest.llmDescription != null)
                        Text(interest.llmDescription!),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchGoogleMaps(
      double destinationLatitude, double destinationLongitude) async {
    final uri = Uri(
        scheme: "google.navigation",
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) => mapController = controller,
      initialCameraPosition: CameraPosition(
        target: initialPosition,
        zoom: 14.0,
      ),
      markers: markers,
    );
  }
}
