import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/all_scripts/res_scripts.dart';
import 'package:jejom/modules/restaurant/script_generator/prompt_details.dart';
import 'package:jejom/providers/restaurant/restaurant_provider.dart';
import 'package:jejom/providers/restaurant/script_generator_provider.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

class RestaurantHome extends StatefulWidget {
  const RestaurantHome({super.key});

  @override
  State<RestaurantHome> createState() => _RestaurantHomeState();
}

class _RestaurantHomeState extends State<RestaurantHome> {
  late RestaurantProvider restaurantProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    restaurantProvider =
        Provider.of<RestaurantProvider>(context, listen: false);
    // restaurantProvider.fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final scriptProvider =
        Provider.of<RestaurantScriptGeneratorProvider>(context);
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  
                  // Main card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mystery Script",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(Icons.theater_comedy, color: Colors.black87),
                                SizedBox(width: 10),
                                Text(
                                  "Create Your Game",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Container(
                                color: Colors.white.withOpacity(0.3),
                                child: TextField(
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    hintText: "Describe your mystery...",
                                    hintStyle: TextStyle(color: Colors.black54),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.black87),
                                  textInputAction: TextInputAction.send,
                                  onChanged: (value) => scriptProvider.updatePrompt(value),
                                  onSubmitted: (value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PromptDetails(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PromptDetails(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                  ),
                                  child: Text("Create Script"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Navigation tabs
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildNavTab(isSelected: true, icon: Icons.edit, label: "Create"),
                      SizedBox(width: 30),
                      buildNavTab(
                        isSelected: false, 
                        icon: Icons.explore, 
                        label: "Scripts",
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const ResScripts(),
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                  
                  Spacer(),
                  
                  // Bottom padding
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget buildNavTab({
    required bool isSelected, 
    required IconData icon, 
    required String label,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon, 
              color: isSelected ? Colors.white : Colors.black54,
              size: 24,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black87 : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
