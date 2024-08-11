import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController mainPageController = PageController();
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Opacity(
              opacity: 0.2,
              child: Center(
                  child: WidgetCircularAnimator(
                innerColor: Theme.of(context).colorScheme.primaryContainer,
                outerColor: Theme.of(context).colorScheme.secondary,
                size: 400,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              )),
            ),
            PageView(
              controller: mainPageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                First(mainPageController: mainPageController),
                Second(mainPageController: mainPageController),
                Third(mainPageController: mainPageController),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class First extends StatelessWidget {
//   final PageController mainPageController;
//   const First({super.key, required this.mainPageController});

//   @override
//   Widget build(BuildContext context) {
//     bool isFinished = false;
//     return
//   }
// }

class First extends StatefulWidget {
  final PageController mainPageController;
  const First({super.key, required this.mainPageController});

  @override
  State<First> createState() => _FirstState();
}

class _FirstState extends State<First> {
  @override
  Widget build(BuildContext context) {
    bool isFinished = false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        Text(
          "Looking for",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text("New Trip", style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        Text(
            "Type in your destinations, budget, duration, interest and number of traveller to get started!",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        const GlassContainer(child: Text("Hello")),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80.0),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromARGB(49, 217, 217, 217),
                  Color.fromARGB(49, 115, 115, 115),
                ],
              ),
              borderRadius: BorderRadius.circular(64.0),
              // border: Border.all(
              //   width: 2,
              //   color: Colors.white.withOpacity(0.3),
              // ),
            ),
            child: SwipeButton(
              width: double.infinity,
              height: 80,
              thumb: Center(
                child: Icon(
                  Icons.travel_explore,
                  size: 32,
                  color: Theme.of(context).colorScheme.background,
                ),
              ),
              activeThumbColor: Theme.of(context).colorScheme.primaryContainer,
              activeTrackColor: Theme.of(context)
                  .colorScheme
                  .secondaryContainer
                  .withOpacity(0),
              child: Text(
                "            Explore",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
              ),
              onSwipe: () {
                widget.mainPageController.animateToPage(1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class Second extends StatelessWidget {
  final PageController mainPageController;
  const Second({super.key, required this.mainPageController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            iconSize: 80,
            onPressed: () {
              mainPageController.animateToPage(0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            icon: const Icon(
              Icons.arrow_back,
              size: 24,
            )),
        const SizedBox(height: 16),
        Text(
          "Where do you want to go?",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
            "Type in your destinations, budget, duration, interest and number of traveller",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 32),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Type Anything!",
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const Spacer(),
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
              onPressed: () {
                mainPageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              child: Text("Let's Go!",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

enum Interest { Adventure, Relax, Culture, Food, Shopping, Nature }

class Third extends StatefulWidget {
  final PageController mainPageController;
  const Third({super.key, required this.mainPageController});

  @override
  State<Third> createState() => _ThirdState();
}

class _ThirdState extends State<Third> {
  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 80),
        IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            onPressed: () {
              widget.mainPageController.animateToPage(1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            },
            icon: const Icon(
              Icons.arrow_back,
              // size: 24,
            )),
        const SizedBox(height: 16),
        Text(
          "Destination",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text("Seperate your destinations with comma (,)",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Rome, Jeju, Tokyo, etc.",
            prefixIcon: const Icon(Icons.location_on_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          "Duration",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        // const SizedBox(height: 16),
        Row(
          children: [
            Text(
                "${startDate.toIso8601String().substring(0, 10)} - ${endDate.toIso8601String().substring(0, 10)}"),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  lastDate: new DateTime(2026),
                  firstDate: DateTime.now(),
                );
                if (picked != null && picked != null) {
                  print(picked);
                  setState(() {
                    startDate = picked.start;
                    endDate = picked.end;
                    //below have methods that runs once a date range is picked
                  });
                }
              },
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        Text(
          "Budget",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "xxx + any currency!",
            prefixIcon: const Icon(Icons.currency_pound_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        const SizedBox(height: 40),
        Text(
          "Interest",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
            Chip(
              avatar: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: const Text('AB'),
              ),
              label: const Text('Aaron Burr'),
            ),
          ],
        ),
        const SizedBox(height: 40),
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
              onPressed: () {
                widget.mainPageController.animateToPage(2,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease);
              },
              child: Text("Let's Go!",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ]),
    );
  }
}
