import 'package:flutter/material.dart';
import 'package:jejom/providers/restaurant/script_generator_provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class PromptDetails extends StatefulWidget {
  const PromptDetails({super.key});

  @override
  State<PromptDetails> createState() => _PromptDetailsState();
}

class _PromptDetailsState extends State<PromptDetails> {
  @override
  Widget build(BuildContext context) {
    final scriptGenerator =
        Provider.of<RestaurantScriptGeneratorProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        iconSize: 80,
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 24,
                        )),
                    const SizedBox(height: 16),
                    Text(
                      "It's almost there!",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    Text("Number of characters?",
                        style: Theme.of(context).textTheme.bodyLarge),
                    // const SizedBox(height: 16),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: NumberPicker(
                  haptics: true,
                  axis: Axis.horizontal,
                  value: scriptGenerator.numberOfCharacters,
                  minValue: 0,
                  maxValue: 10,
                  itemCount: 5,
                  onChanged: (value) =>
                      scriptGenerator.updateNumberOfCharacters(value),
                ),
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
                        const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    onPressed: () => scriptGenerator.sendPrompt(),
                    child: Text("Let's Go!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            )),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
