import 'package:flutter/material.dart';
import 'package:jejom/modules/explore/explore.dart';
import 'package:jejom/modules/food/ocr.dart';
import 'package:jejom/modules/maps/map.dart';
import 'package:jejom/modules/onboarding/onboarding_wrapper.dart';
import 'package:jejom/modules/script_game/game_list.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:o3d/o3d.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  O3DController controller = O3DController();

  @override
  Widget build(BuildContext context) {
    final TripProvider tripProvider = Provider.of<TripProvider>(context);
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(0, 300),
              child: Image.asset(
                'assets/images/earth.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            // AbsorbPointer(
            //   absorbing: true,
            //   child: O3D(
            //     src: 'assets/suitcases.glb',
            //     controller: controller,
            //     interactionPrompt: InteractionPrompt.none,
            //     ar: false,
            //     scale: "0.5 0.5 0.5",
            //     fieldOfView: "24deg",
            //     cameraTarget: CameraTarget(1.2, 1, 1),
            //     cameraOrbit: CameraOrbit(23, 49, 1),
            //     disablePan: true,
            //     disableTap: true,
            //     disableZoom: true,
            //     autoRotate: true,
            //     rotationPerSecond: "2deg",
            //     touchAction: TouchAction.none,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to Jejom",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6),
                          )),
                  const SizedBox(height: 8),
                  Text("Plan The",
                      style: Theme.of(context).textTheme.headlineLarge),
                  Text("Best Trip To The",
                      style: Theme.of(context).textTheme.headlineLarge),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Vacation",
                      suffixIcon: const Icon(Icons.location_on_rounded),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    textInputAction: TextInputAction.send,
                    onSubmitted: (value) {
                      onboardingProvider.updatePrompt(value);
                      onboardingProvider.sendPrompt();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const OnBoarding(isOnboarding: false),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Spacer(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MapPage(),
                            ),
                          );
                        },
                        child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.map_rounded,
                              color: Theme.of(context).colorScheme.background,
                            )),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MenuOCRPage(),
                            ),
                          );
                        },
                        child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.restaurant_menu_rounded,
                              color: Theme.of(context).colorScheme.background,
                            )),
                      ),
                      const SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const GameList(),
                            ),
                          );
                        },
                        child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onBackground,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.local_play_rounded,
                              color: Theme.of(context).colorScheme.background,
                            )),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const Explore(),
                            ),
                          );
                        },
                        child: Container(
                            width: 64,
                            height: 64,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                width: 2,
                              ),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Icon(
                              Icons.explore_rounded,
                              color: Theme.of(context).colorScheme.background,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  tripProvider.trips.isEmpty
                      ? const SizedBox()
                      : GlassContainer(
                          padding: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ClipRRect(
                              //   borderRadius: const BorderRadius.only(
                              //     topLeft: Radius.circular(16.0),
                              //     bottomLeft: Radius.circular(16.0),
                              //   ),
                              //   child: Image.network(
                              //     tripProvider
                              //         .trips.first.destinations.first.imageUrl.first,
                              //     width: 160,
                              //     height: 120,
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Current Trip",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge),
                                      const SizedBox(height: 8),
                                      Text(tripProvider.trips.first.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
