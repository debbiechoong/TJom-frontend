import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jejom/modules/user/explore/explore.dart';
import 'package:jejom/modules/user/explore/map.dart';
import 'dart:ui';

enum ExploreName { list, map }

class ExploreWrapper extends StatefulWidget {
  const ExploreWrapper({super.key});

  @override
  State<ExploreWrapper> createState() => _ExploreWrapperState();
}

class _ExploreWrapperState extends State<ExploreWrapper> {
  final PageController _explorePageController = PageController();
  ExploreName calendarView = ExploreName.list;

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
                const SizedBox(height: 16),
                
                // Header with back button and view toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      GestureDetector(
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
                      const Spacer(),
                      
                      // View toggle button
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        calendarView = ExploreName.list;
                                        _explorePageController.animateToPage(0,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: calendarView == ExploreName.list 
                                          ? Colors.black87 
                                          : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.list,
                                            size: 18,
                                            color: calendarView == ExploreName.list 
                                              ? Colors.white 
                                              : Colors.black87,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'List',
                                            style: TextStyle(
                                              color: calendarView == ExploreName.list 
                                                ? Colors.white 
                                                : Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        calendarView = ExploreName.map;
                                        _explorePageController.animateToPage(1,
                                          duration: const Duration(milliseconds: 300),
                                          curve: Curves.easeInOut);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: calendarView == ExploreName.map 
                                          ? Colors.black87 
                                          : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.map,
                                            size: 18,
                                            color: calendarView == ExploreName.map 
                                              ? Colors.white 
                                              : Colors.black87,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Map',
                                            style: TextStyle(
                                              color: calendarView == ExploreName.map 
                                                ? Colors.white 
                                                : Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Content area (PageView)
                Expanded(
                  child: PageView(
                    controller: _explorePageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      Explore(),
                      MapPage(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
