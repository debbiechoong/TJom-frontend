import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jejom/providers/user/user_provider.dart';
import 'dart:ui';

class MealPreferences extends StatefulWidget {
  final Function? onPreferencesUpdated;
  
  const MealPreferences({super.key, this.onPreferencesUpdated});

  @override
  State<MealPreferences> createState() => _MealPreferencesState();
}

class _MealPreferencesState extends State<MealPreferences> {
  final List<String> _availableDietaryCategories = [
    'Regular',
    'Vegetarian',
    'Vegan',
    'Pescatarian'
  ];

  final List<String> _availableAllergies = [
    'Nuts',
    'Dairy',
    'Shellfish',
    'Gluten',
    'Eggs',
    'Soy',
    'Fish'
  ];

  String _selectedDietaryCategory = 'Regular';
  final List<String> _selectedAllergies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;
      if (user != null) {
        setState(() {
          _selectedDietaryCategory = user.dietary.isNotEmpty ? user.dietary : 'Regular';
          _selectedAllergies.addAll(user.allergies);
        });
      }
    });
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
      } else {
        _selectedAllergies.add(allergy);
      }
    });
  }

  void _savePreferences() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateDietaryPreferences(
      dietary: _selectedDietaryCategory,
      allergies: _selectedAllergies,
    );
    if (widget.onPreferencesUpdated != null) {
      widget.onPreferencesUpdated!();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),
          
          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),
          
          SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GestureDetector(
                    onTap: () {
                  Navigator.pop(context);
                },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.black54),
                    ),
                  ),
                ),
                
                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Text(
                          "Meal Preferences",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        
                        const SizedBox(height: 12),
                        
                        const Text(
                          "Tell us your dietary preferences so we can help you find suitable food options.",
                          style: TextStyle(
                            fontSize: 16, 
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Dietary preferences section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Dietary Preference",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Dietary options
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: _availableDietaryCategories.map((dietary) {
                                      final isSelected = _selectedDietaryCategory == dietary;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedDietaryCategory = dietary;
                                          });
                                        },
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
                                          child: Text(
                                            dietary,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Allergies section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Allergies",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  const Text(
                                    "Select all that apply",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Allergies options
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: _availableAllergies.map((allergy) {
                                      final isSelected = _selectedAllergies.contains(allergy);
                                      return GestureDetector(
                                        onTap: () => _toggleAllergy(allergy),
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
                                          child: Text(
                                            allergy,
                                            style: TextStyle(
                                              color: isSelected ? Colors.white : Colors.black87,
                                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Save button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: GestureDetector(
                    onTap: _savePreferences,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Save Preferences",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
