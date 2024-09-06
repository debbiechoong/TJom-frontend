import 'package:flutter/material.dart';

class AdminOnboarding extends StatefulWidget {
  const AdminOnboarding({super.key});

  @override
  State<AdminOnboarding> createState() => _AdminOnboardingState();
}

class _AdminOnboardingState extends State<AdminOnboarding> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            "Restaurant Onboarding",
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
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            // onChanged: (value) => onBoardingProvider.setName(value),
          ),
          const SizedBox(height: 32),
          Text("A Short Desc About yourself!",
              style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
