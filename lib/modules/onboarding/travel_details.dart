import 'package:flutter/material.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:provider/provider.dart';

enum Interest { Adventure, Relax, Culture, Food, Shopping, Nature }

class TravelDetails extends StatefulWidget {
  const TravelDetails({super.key});

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  Set<Interest> selectedInterests = {};
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnboardingProvider>(context);

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 80),
        IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            onPressed: () => onBoardingProvider.previousPage(),
            icon: const Icon(
              Icons.arrow_back,
              // size: 24,
            )),
        const SizedBox(height: 16),
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
        ),
        const SizedBox(height: 40),
        Text(
          "Duration",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        // const SizedBox(height: 16),
        Row(
          children: [
            Text(
                "${startDate.toIso8601String().substring(0, 10)} - ${endDate.toIso8601String().substring(0, 10)}"),
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
                    startDate = picked.start;
                    endDate = picked.end;
                    //below have methods that runs once a date range is picked
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        ),
        const SizedBox(height: 40),
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
          maxLines: null,
          decoration: InputDecoration(
            hintText: "xxx + any currency!",
            prefixIcon: const Icon(Icons.currency_pound_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 40),
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
              selected: selectedInterests.contains(interest),
              onSelected: (selected) {
                setState(() {
                  selected
                      ? selectedInterests.add(interest)
                      : selectedInterests.remove(interest);
                });
              },
              // selectedColor: Colors.lightGreenAccent,
              // backgroundColor: Colors.grey.shade200,
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
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
              onPressed: () => onBoardingProvider.nextPage(),
              child: Text("I'm in!",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}
