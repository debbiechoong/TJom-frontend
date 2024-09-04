import 'package:flutter/material.dart';
import 'package:jejom/providers/travel_provider.dart';
import 'package:provider/provider.dart';

class Prompt extends StatelessWidget {
  const Prompt({super.key});

  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            iconSize: 80,
            onPressed: () => travelProvider.previousPage(),
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            )),
        const SizedBox(height: 16),
        Text(
          "Where do you want to go?",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
            "Type in your destinations, budget, interests, start and end date",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Type Anything!",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) => travelProvider.updatePrompt(value),
        ),
        const Spacer(),
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
              onPressed: () => travelProvider.sendPrompt(),
              child: Text("Let's Go!",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
