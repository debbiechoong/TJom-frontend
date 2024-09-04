import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jejom/providers/user_provider.dart';
import 'package:jejom/models/user.dart';

class MealPreferences extends StatefulWidget {
  final VoidCallback onPreferencesUpdated;
  const MealPreferences({required this.onPreferencesUpdated, super.key});

  @override
  _MealPreferencesState createState() => _MealPreferencesState();
}

class _MealPreferencesState extends State<MealPreferences> {
  final TextEditingController _allergyController = TextEditingController();
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
              
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFoodTypeRadioButtons() {
    return [
      _buildFoodTypeRadioButton("Everything"),
      _buildFoodTypeRadioButton("Vegetarian"),
      _buildFoodTypeRadioButton("Vegan"),
    ];
  }

  Widget _buildFoodTypeRadioButton(String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: RadioListTile<String>(
        title: Text(value),
        value: value.toLowerCase(),
        groupValue: _selectedFoodType,
        onChanged: (String? value) {
          setState(() {
            _selectedFoodType = value!;
          });
        },
      ),
    );
  }

  void _submitPreferences() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final allergies =
        _allergyController.text.split(',').map((e) => e.trim()).toList();

    userProvider.updateUserAllergies(allergies);
    userProvider.updateUserDietary(_selectedFoodType);

    Navigator.pop(context);
    widget.onPreferencesUpdated();
  }
}
