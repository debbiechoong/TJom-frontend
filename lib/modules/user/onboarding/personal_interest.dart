import 'package:flutter/material.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';

class PersonalInterest extends StatefulWidget {
  const PersonalInterest({super.key});

  @override
  State<PersonalInterest> createState() => _PersonalInterestState();
}

class _PersonalInterestState extends State<PersonalInterest> {
  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnboardingProvider>(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 80),
          IconButton(
              visualDensity: VisualDensity.adaptivePlatformDensity,
              iconSize: 80,
              onPressed: () => onBoardingProvider.previousPage(),
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
              )),
          const SizedBox(height: 16),
          Text(
            "Help us personalize your experience!",
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 32),
          Text("Your Nickname?", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "You can call me...",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) => onBoardingProvider.setName(value),
          ),
          const SizedBox(height: 32),
          Text("A Short Desc About yourself!",
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "I am an INFJ, loves fishing...",
              prefixIcon: const Icon(Icons.interests),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) => onBoardingProvider.setDesc(value),
          ),
          const SizedBox(height: 32),
          _buildInterest(onBoardingProvider),
          Text("Residing City", style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "New York",
              prefixIcon: const Icon(Icons.location_city),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onChanged: (value) => onBoardingProvider.setResidingCity(value),
          ),
          // Removed Spacer and added SizedBox for spacing at the end
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
                child: Text("Let's Go!",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInterest(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Interest", style: Theme.of(context).textTheme.bodyLarge),
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
            );
          }).toList(),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}

enum Interest { Adventure, Relax, Culture, Food, Shopping, Nature }
