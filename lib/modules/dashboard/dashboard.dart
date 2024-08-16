import 'package:crystal_navigation_bar/crystal_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jejom/modules/explore/explore.dart';
import 'package:jejom/modules/food/menu.dart';
import 'package:jejom/modules/home/home.dart';
import 'package:jejom/modules/maps/map.dart';
import 'package:o3d/o3d.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var _selectedTab = _SelectedTab.dashboard;
  final PageController _mainPageController = PageController();

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
    _mainPageController.jumpToPage(i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          PageView(
            controller: _mainPageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Home(),
              Explore(),
              MapPage(),
              MealPreferences(),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 16),
      //   child: CrystalNavigationBar(
      //     currentIndex: _SelectedTab.values.indexOf(_selectedTab),
      //     unselectedItemColor: Theme.of(context).colorScheme.primary,
      //     backgroundColor: Theme.of(context).colorScheme.background,
      //     // outlineBorderColor: Colors.black.withOpacity(0.1),
      //     borderRadius: 16,
      //     // itemPadding: const EdgeInsets.all(0),
      //     // paddingR: const EdgeInsets.all(0),
      //     // margin: const EdgeInsets.all(0),
      //     // marginR: const EdgeInsets.all(0),
      //     height: 120,
      //     onTap: _handleIndexChanged,
      //     items: [
      //       CrystalNavigationBarItem(
      //         icon: Icons.dashboard_rounded,
      //         unselectedIcon: Icons.dashboard_outlined,
      //         selectedColor: Theme.of(context).colorScheme.primaryContainer,
      //       ),
      //       CrystalNavigationBarItem(
      //         icon: Icons.explore_rounded,
      //         unselectedIcon: Icons.explore_outlined,
      //         selectedColor: Theme.of(context).colorScheme.primaryContainer,
      //       ),
      //       CrystalNavigationBarItem(
      //         icon: Icons.map_rounded,
      //         unselectedIcon: Icons.map_outlined,
      //         selectedColor: Theme.of(context).colorScheme.primaryContainer,
      //       ),
      //       CrystalNavigationBarItem(
      //         icon: Icons.restaurant_menu_rounded,
      //         unselectedIcon: Icons.restaurant_menu_outlined,
      //         selectedColor: Theme.of(context).colorScheme.primaryContainer,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

enum _SelectedTab { dashboard, explore, map, menu }
