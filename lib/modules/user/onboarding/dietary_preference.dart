import 'package:flutter/material.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';

class DietaryPreferences extends StatefulWidget {
  const DietaryPreferences({super.key});

  @override
  State<DietaryPreferences> createState() => _DietaryPreferencesState();
}

class _DietaryPreferencesState extends State<DietaryPreferences> {
  @override
  Widget build(BuildContext context) {
    final onBoardingProvider = Provider.of<OnboardingProvider>(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
        ),
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
              "Food Preferences & Allergies",
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text("Type of food", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            ..._buildFoodTypeRadioButtons(),
            const SizedBox(height: 32),
            Text("Allergens", style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text("Enter your allergens (separated by commas)",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'egg, milk, peanuts',
              ),
              onChanged: (value) => onBoardingProvider.setAllergies(value),
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
                  onPressed: onBoardingProvider.isLoading
                      ? null // Disable the button when loading
                      : () => onBoardingProvider.updateUser(),
                  child: onBoardingProvider.isLoading
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              "Loading...",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                            ),
                          ],
                        )
                      : Text(
                          "Let's Go!",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                        ),
                )
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFoodTypeRadioButtons() {
    return [
      _buildFoodTypeRadioButton("Everything"),
      _buildFoodTypeRadioButton("Vegetarian"),
      _buildFoodTypeRadioButton("Vegan"),
      _buildFoodTypeRadioButton("Halal"),
    ];
  }

  Widget _buildFoodTypeRadioButton(String value) {
    final onBoardingProvider = Provider.of<OnboardingProvider>(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: RadioListTile<String>(
        title: Text(value),
        value: value.toLowerCase(),
        groupValue: onBoardingProvider.dietary,
        onChanged: (String? value) => onBoardingProvider.setDietary(value!),
      ),
    );
  }

  // void _submitPreferences() {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   final allergies =
  //       _allergyController.text.split(',').map((e) => e.trim()).toList();

  //   userProvider.updateUserAllergies(allergies);
  //   userProvider.updateUserDietary(_selectedFoodType);

  //   Navigator.pop(context);
  //   // widget.onPreferencesUpdated();
  // }
}
