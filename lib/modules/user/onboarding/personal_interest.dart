import 'package:flutter/material.dart';
import 'package:jejom/providers/user/onboarding_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

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
            Text(
              "Help us personalize your experience!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Nickname field
            Text(
              "Your Nickname?", 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildGlassmorphicTextField(
              hintText: "You can call me...",
              prefixIcon: Icons.person,
              onChanged: (value) => onBoardingProvider.setName(value),
            ),
            
            const SizedBox(height: 32),
            
            // About field
            Text(
              "A Short Desc About yourself!",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildGlassmorphicTextField(
              hintText: "I am an INFJ, loves fishing...",
              prefixIcon: Icons.interests,
              onChanged: (value) => onBoardingProvider.setDesc(value),
            ),
            
            const SizedBox(height: 32),
            
            // Interests section
            _buildInterest(onBoardingProvider),
            
            // Residing city field
            Text(
              "Residing City", 
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildGlassmorphicTextField(
              hintText: "New York",
              prefixIcon: Icons.location_city,
              onChanged: (value) => onBoardingProvider.setResidingCity(value),
            ),
            
            const SizedBox(height: 40),
            
            // Continue button
            GestureDetector(
              onTap: () => onBoardingProvider.nextPage(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Continue",
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

  Widget _buildGlassmorphicTextField({
    required String hintText,
    required IconData prefixIcon,
    required Function(String) onChanged,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.black54),
              prefixIcon: Icon(prefixIcon, color: Colors.black54),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.black87),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget _buildInterest(OnboardingProvider onBoardingProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Interest", 
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 12),
        
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
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

                  final isSelected = onBoardingProvider.selectedInterests.contains(interest);
                  
                  return GestureDetector(
                    onTap: () => onBoardingProvider.toggleInterest(interest),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected 
                          ? Colors.black87
                          : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                            ? Colors.black87
                            : Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            icon,
                            color: isSelected ? Colors.white : Colors.black87,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
      ],
    );
  }
}

enum Interest { Adventure, Relax, Culture, Food, Shopping, Nature }
