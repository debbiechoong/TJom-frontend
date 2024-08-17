import 'package:flutter/material.dart';

class MealPreferences extends StatefulWidget {
  const MealPreferences({super.key});

  @override
  _MealPreferencesState createState() => _MealPreferencesState();
}

class _MealPreferencesState extends State<MealPreferences> {
  double _budgetLevel = 50;
  final double _maxBudget = 100;

  bool _includeBreakfast = false;
  bool _includeLunch = false;
  bool _includeDinner = false;

  String _selectedFoodType = "everything";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Meals preferences",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Select the meals you would like to include in your trip, your budget for it, and the type of food you prefer.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                "Budget level",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Depending on the budget level, we will select least or more expensive restaurants.",
                style: TextStyle(fontSize: 14),
              ),
              Slider(
                value: _budgetLevel,
                min: 0,
                max: _maxBudget,
                divisions: 2,
                label: _budgetLevel.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _budgetLevel = value;
                  });
                },
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Cheap", style: TextStyle(fontSize: 14)),
                  Text("Mid", style: TextStyle(fontSize: 14)),
                  Text("High", style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Meals to include",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text(
                "Prices are an estimate of each meal for 8 days 1 person",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: CheckboxListTile(
                  value: _includeBreakfast,
                  title: const Text("Breakfast"),
                  subtitle: const Text("\$16\n(\$2 per meal)"),
                  onChanged: (bool? value) {
                    setState(() {
                      _includeBreakfast = value ?? false;
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: CheckboxListTile(
                  value: _includeLunch,
                  title: const Text("Lunch"),
                  subtitle: const Text("\$29\n(\$4 per meal)"),
                  onChanged: (bool? value) {
                    setState(() {
                      _includeLunch = value ?? false;
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: CheckboxListTile(
                  value: _includeDinner,
                  title: const Text("Dinner"),
                  subtitle: const Text("\$30\n(\$4 per meal)"),
                  onChanged: (bool? value) {
                    setState(() {
                      _includeDinner = value ?? false;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Type of food",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: RadioListTile<String>(
                  title: const Text("Everything"),
                  value: "everything",
                  groupValue: _selectedFoodType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFoodType = value!;
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: RadioListTile<String>(
                  title: const Text("Vegetarian"),
                  value: "vegetarian",
                  groupValue: _selectedFoodType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFoodType = value!;
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: RadioListTile<String>(
                  title: const Text("Vegan"),
                  value: "vegan",
                  groupValue: _selectedFoodType,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFoodType = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitPreferences,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF65558F),
                  ),
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPreferences() {
    Map<String, dynamic> preferences = {
      'budgetLevel': _budgetLevel,
      'includeBreakfast': _includeBreakfast,
      'includeLunch': _includeLunch,
      'includeDinner': _includeDinner,
      'selectedFoodType': _selectedFoodType,
    };

    print("User Preferences: $preferences");
  }
}
