import 'package:flutter/material.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/utils/loading_screen.dart';
import 'package:provider/provider.dart';

enum Interest { Adventure, Relax, Culture, Food, Shopping, Nature }

class TravelDetails extends StatefulWidget {
  const TravelDetails({super.key});

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  @override
  Widget build(BuildContext context) {
    final OnboardingProvider onBoardingProvider =
        Provider.of<OnboardingProvider>(context);

    return onBoardingProvider.isLoading
        ? const LoadingWidget()
        : SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 80),
              IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: () => onBoardingProvider.previousPage(),
                  icon: const Icon(
                    Icons.arrow_back,
                    // size: 24,
                  )),
              const SizedBox(height: 16),
              onBoardingProvider.isDestination
                  ? _buildDestination(onBoardingProvider)
                  : const SizedBox(),
              onBoardingProvider.isDuration
                  ? _buildDuration(onBoardingProvider)
                  : const SizedBox(),
              onBoardingProvider.isBudget
                  ? _buildBudget(onBoardingProvider)
                  : const SizedBox(),
              onBoardingProvider.isInterest
                  ? _buildInterest(onBoardingProvider)
                  : const SizedBox(),
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
                    onPressed: () => onBoardingProvider.sendTravelDetails(),
                    child: Text("I'm in!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ]),
          );
  }

  Widget _buildDestination(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Destination",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text("Seperate your destinations with comma (,)",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Rome, Jeju, Tokyo, etc.",
            prefixIcon: const Icon(Icons.location_on_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) => onBoardingProvider.updateDestination(value),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDuration(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Duration",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
                "${onBoardingProvider.startDate.toIso8601String().substring(0, 10)} - ${onBoardingProvider.endDate.toIso8601String().substring(0, 10)}"),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  lastDate: DateTime(2026),
                  firstDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    onBoardingProvider.startDate = picked.start;
                    onBoardingProvider.endDate = picked.end;
                    //below have methods that runs once a date range is picked
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBudget(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Budget",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            hintText: "xxx + any currency!",
            prefixIcon: const Icon(Icons.currency_pound_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) => onBoardingProvider.updateBudget(value),
          
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildInterest(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Interest",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: Interest.values.map((interest) {
            IconData icon;
            String label;

            switch (interest) {
              case Interest.Adventure:
                icon = Icons.directions_walk;
                label = "Adventure";
                break;
              case Interest.Relax:
                icon = Icons.spa;
                label = "Relax";
                break;
              case Interest.Culture:
                icon = Icons.museum;
                label = "Culture";
                break;
              case Interest.Food:
                icon = Icons.restaurant;
                label = "Food";
                break;
              case Interest.Shopping:
                icon = Icons.shopping_bag;
                label = "Shopping";
                break;
              case Interest.Nature:
                icon = Icons.park;
                label = "Nature";
                break;
            }

            return ChoiceChip(
              avatar: Icon(icon),
              label: Text(label),
              showCheckmark: false,
              selected: onBoardingProvider.selectedInterests.contains(interest),
              onSelected: (selected) {
                onBoardingProvider.toggleInterest(interest);
              },
              // selectedColor: Colors.lightGreenAccent,
              // backgroundColor: Colors.grey.shade200,
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
