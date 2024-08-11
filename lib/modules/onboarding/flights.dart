import 'package:flutter/material.dart';
import 'package:jejom/utils/glass_container.dart';

class Flights extends StatefulWidget {
  const Flights({super.key});

  @override
  State<Flights> createState() => _FlightsState();
}

class _FlightsState extends State<Flights> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 80),
        IconButton(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              // size: 24,
            )),
        const SizedBox(height: 16),
        Text(
          "Flights",
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text("Kuala Lumpur to Jeju",
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Kuala Lumpur to Jeju",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("Departure: 12:00 PM - 2:00 PM",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("Arrival: 3:00 PM",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("Duration: 3 hours",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("Price: RM 500", style: Theme.of(context).textTheme.bodyLarge),
          ],
        )),
        const Spacer(),
      ],
    );
  }
}
