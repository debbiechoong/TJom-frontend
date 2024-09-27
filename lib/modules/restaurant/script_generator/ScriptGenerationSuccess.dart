import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/home/restaurant_home.dart';

class ScriptGenerationSuccess extends StatelessWidget {
  const ScriptGenerationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Script Generated!",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "Your custom mystery murder game script has been created.",
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const RestaurantHome(),
                    ),
                    (route) => false,
                  );
                },
                child: Text("Go to Home",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
