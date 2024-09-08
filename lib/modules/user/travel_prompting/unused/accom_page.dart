import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jejom/models/acccomodation.dart';
import 'package:jejom/providers/user/accomodation_provider.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';

class AccomPage extends StatefulWidget {
  const AccomPage({super.key});

  @override
  State<AccomPage> createState() => _AccomPageState();
}

class _AccomPageState extends State<AccomPage> {
  @override
  Widget build(BuildContext context) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    final accommodationProvider = Provider.of<AccommodationProvider>(context);

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
                // size: 24,
              )),
          const SizedBox(height: 16),
          Text(
            "Accommodations",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            "Select your accommodation",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          AnimationLimiter(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: accommodationProvider.accommodations.length,
                itemBuilder: (context, index) {
                  final accom = accommodationProvider.accommodations[index];
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
                          child: accomCard(
                              accom: accom,
                              isSelected:
                                  accommodationProvider.selectedAccommodation !=
                                          null &&
                                      accommodationProvider
                                              .selectedAccommodation!.name ==
                                          accom.name),
                        ),
                      ),
                    ),
                  );
                },
              ),
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget accomCard({required Accommodation accom, required bool isSelected}) {
    final onboardingProvider = Provider.of<OnboardingProvider>(context);
    final accommodationProvider = Provider.of<AccommodationProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1)
            : null,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${accom.name}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // const SizedBox(height: 8),
                Text(
                  '${accom.address}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.8),
                      ),
                ),
                // const SizedBox(height: 8),
                Text(
                  '${accom.price}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  accommodationProvider.toggleSelectedAccommodation(accom);
                },
                child: Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? null
                          : Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
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
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
