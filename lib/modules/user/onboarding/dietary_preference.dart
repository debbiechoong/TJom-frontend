import 'package:flutter/material.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            
            // Back button
            GestureDetector(
              onTap: () => onBoardingProvider.previousPage(),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black54),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            const Text(
              "Food Preferences & Allergies",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 16),
            
            const Text(
              "Tell us your preferences to help you find suitable food options",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Food types section
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Type of food",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      ..._buildFoodTypeRadioButtons(),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Allergens section
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Allergens",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      const Text(
                        "Enter your allergens (separated by commas)",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'egg, milk, peanuts',
                          hintStyle: const TextStyle(color: Colors.black54),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        onChanged: (value) => onBoardingProvider.setAllergies(value),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Complete button
            GestureDetector(
              onTap: onBoardingProvider.isLoading
                ? null
                : () => onBoardingProvider.updateUser(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: onBoardingProvider.isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    "Let's Go!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ),
            ),
            
            const SizedBox(height: 32),
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
    final isSelected = value.toLowerCase() == onBoardingProvider.dietary;
    
    return GestureDetector(
      onTap: () => onBoardingProvider.setDietary(value.toLowerCase()),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected 
            ? Colors.black.withOpacity(0.1) 
            : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
              ? Colors.black.withOpacity(0.2)
              : Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                  ? Colors.black87
                  : Colors.white.withOpacity(0.3),
                border: isSelected 
                  ? null
                  : Border.all(color: Colors.black38, width: 1.5),
              ),
              child: isSelected 
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
            ),
            const SizedBox(width: 16),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
