import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/onboarding/restaurant_image.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:provider/provider.dart';

class RestaurantDetails extends StatefulWidget {
  const RestaurantDetails({super.key});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
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
                "Restaurant Details",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text("Restaurant Name",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "The Best Jeju Cafe",
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) => onBoardingProvider.setName(value),
              ),
              const SizedBox(height: 32),
              Text("A Short Desc about your Restaurant!",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Located admist the mountain...",
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) => onBoardingProvider.setDescription(value),
              ),
              const SizedBox(height: 32),
              Text("Phone Number", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "+8210-1234-5678",
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) => onBoardingProvider.setPhoneNum(value),
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
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const RestaurantImage(),
                      ),
                    ),
                    child: Text("Next",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
