import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/destination.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/trip_provider.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:provider/provider.dart';

class Itinerary extends StatefulWidget {
  const Itinerary({super.key});

  @override
  State<Itinerary> createState() => _ItineraryState();
}

class _ItineraryState extends State<Itinerary> {
  get onPressed => null;

  @override
  Widget build(BuildContext context) {
    final tripProvider = Provider.of<TripProvider>(context);
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    String prompt = "";

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              onPressed: () {
                onboardingProvider.previousPage();
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          const SizedBox(height: 16),
          Text(
            "Itinerary",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tripProvider.trips.length,
              itemBuilder: (context, index) {
                final trip = tripProvider.trips[index];

                //Sort the destination according to days and time
                //Build a new array is it is the next day
                List<List<Destination>> destinations = [[]];

                for (int i = 0; i < trip.destinations.length; i++) {
                  if (i == 0) {
                    destinations[destinations.length - 1]
                        .add(trip.destinations[i]);
                  } else {
                    if (trip.destinations[i].startDate.day !=
                        trip.destinations[i - 1].startDate.day) {
                      destinations.add([]);
                    }
                    destinations[destinations.length - 1]
                        .add(trip.destinations[i]);
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip.title,
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: M3Carousel(
                        slideAnimationDuration: 300, // milliseconds
                        titleFadeAnimationDuration: 200, // milliseconds
                        children: [
                          ...destinations.map((dayDestination) {
                            return dayDestination.map((des) =>
                                {"image": des.imageUrl[0], "title": des.name});
                          }).expand((i) => i),
                        ],
                      ),
                    ),
                    MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: destinations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                      "Day ${index + 1}  •  ${DateFormat('dd MMM yyyy').format(trip.startDate.add(Duration(days: index)))}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 16),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {
                                        showAnimatedDialog(context,
                                            icon: Icons.edit_rounded,
                                            title:
                                                "Edit Day ${index + 1} Itinerary",
                                            desc:
                                                "How would you like to change it?",
                                            buttonText: "Submit",
                                            onPressed: () {
                                          tripProvider.sendNewPrompt(
                                              prompt, trip.id);
                                        }, prompt: prompt);
                                      },
                                      icon: const Icon(Icons.edit_rounded)),
                                ],
                              ),
                              const SizedBox(height: 16),
                              destinations[index].isNotEmpty
                                  ? _buildDestinationCard(destinations, index)
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Spacer(),
              FilledButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.primaryContainer),
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
                onPressed: () {
                  onboardingProvider.nextPage();
                },
                child: Text("Next",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationCard(
      List<List<Destination>> destinations, int index) {
    return Column(
      children: destinations[index]
          .map((destination) => Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          destination.imageUrl[0],
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              destination.name,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              destination.description,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.8)),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Row(
                              children: [
                                Chip(
                                    label: Text(
                                  '${DateFormat('kk:mm a').format(destination.startDate.toLocal())} - ${DateFormat('kk:mm a').format(destination.endDate.toLocal())}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                )),
                                Text("  •  KRW${destination.price}",
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(),
                ],
              ))
          .toList(),
    );
  }

  Future showAnimatedDialog(BuildContext context,
      {IconData? icon,
      required String title,
      required String desc,
      required String buttonText,
      required Function() onPressed,
      required String prompt}) async {
    final colors = Theme.of(context).colorScheme;
    // final tripProvider = Provider.of<TripProvider>(context);

    List<Widget> dialogWidgets = [
      Icon(
        icon,
        color: colors.primary,
        size: 32,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          desc,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Material(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Enter your prompt here",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) => setState(() {
              prompt = value;
            }),
          ),
        ),
      ),
    ];
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, child) {
          return AnimatedOpacity(
            opacity: a1.value,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: Container(
                height: 312,
                alignment: Alignment.topCenter,
                child: AnimatedContainer(
                  height: a1.value * 312,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  duration: const Duration(milliseconds: 500),
                  curve: EMPHASIZED_DECELERATE,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 24),
                                ...dialogWidgets.asMap().entries.map((e) {
                                  int index = e.key;
                                  Widget widget = e.value;
                                  return AnimatedOpacity(
                                    duration: Duration(
                                        milliseconds: 500 + index * 1000),
                                    curve: EMPHASIZED_DECELERATE,
                                    opacity: a1.value,
                                    child: widget,
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          right: 24,
                          width: MediaQuery.of(context).size.width * 0.8 - 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: colors.onPrimary,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              FilledButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context)
                                          .colorScheme
                                          .primaryContainer),
                                  visualDensity:
                                      VisualDensity.adaptivePlatformDensity,
                                ),
                                onPressed: () {
                                  onPressed();
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  buttonText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge!
                                      .copyWith(
                                        color: colors.onPrimary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return const SizedBox();
        });
  }
}
