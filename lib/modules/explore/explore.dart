import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:jejom/providers/interest_provider.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    )),
                const SizedBox(height: 16),
                Text(
                  "Explore Top Destinations",
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("See what other travelers are interested in",
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                Consumer<InterestProvider>(
                  builder: (context, interestProvider, child) {
                    if (interestProvider.interests == null) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (interestProvider.interests!.isEmpty) {
                      return const Center(child: Text("No destinations found"));
                    }

                    return AnimationLimiter(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: interestProvider.interests!.length,
                          itemBuilder: (context, index) {
                            final destination =
                                interestProvider.interests![index];
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                curve: EMPHASIZED_DECELERATE,
                                child: FadeInAnimation(
                                  curve: EMPHASIZED_DECELERATE,
                                  child: GlassContainer(
                                    padding: 0,
                                    marginBottom: 16,
                                    width: double.infinity,
                                    child: destinationCard(
                                        destination: destination,
                                        isSelected: false),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Gih ming code de
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

  Widget destinationCard(
      {required InterestDestination destination, required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              destination.imageUrl.isNotEmpty
                  ? destination.imageUrl[0]
                  : 'assets/images/image1.jpg',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/image1.jpg',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  destination.description,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () =>
                    launchGoogleMaps(destination.lat, destination.long),
                child: Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: isSelected
                        ? null
                        : Border.all(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            width: 2,
                          ),
                    color: isSelected
                        ? Theme.of(context).colorScheme.primaryContainer
                        : null,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isSelected
                        ? const Icon(Icons.check)
                        : Transform.rotate(
                            angle: 1.5708 / 2,
                            child: const Icon(Icons.arrow_upward_rounded),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
