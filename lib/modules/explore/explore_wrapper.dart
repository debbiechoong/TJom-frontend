import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jejom/modules/explore/explore.dart';
import 'package:jejom/modules/explore/map.dart';

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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(),
                  SegmentedButton<ExploreName>(
                    segments: const <ButtonSegment<ExploreName>>[
                      ButtonSegment<ExploreName>(
                          value: ExploreName.list,
                          label: Text('List'),
                          icon: Icon(Icons.list)),
                      ButtonSegment<ExploreName>(
                          value: ExploreName.map,
                          label: Text('Map'),
                          icon: Icon(Icons.map)),
                    ],
                    selected: <ExploreName>{calendarView},
                    onSelectionChanged: (Set<ExploreName> newSelection) {
                      setState(() {
                        calendarView = newSelection.first;
                        if (calendarView == ExploreName.list) {
                          _explorePageController.animateToPage(0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        } else {
                          _explorePageController.animateToPage(1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut);
                        }
                      });
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Divider(endIndent: 0, indent: 0, height: 1),
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
    );
  }
}
