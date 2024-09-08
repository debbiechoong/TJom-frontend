import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/script_generator/character_details.dart';
import 'package:jejom/modules/user/travel_prompting/travel_wrapper.dart';
import 'package:jejom/providers/restaurant/restaurant_provider.dart';
import 'package:jejom/providers/restaurant/script_generator_provider.dart';
import 'package:provider/provider.dart';

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
    restaurantProvider.fetchRestaurant();
  }

  @override
  Widget build(BuildContext context) {
    final scriptProvider = Provider.of<RestaurantScriptGeneratorProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Transform.translate(
              offset: const Offset(-10, 200),
              child: Image.asset(
                'assets/images/door.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Welcome to Jejom",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onBackground
                                .withOpacity(0.6),
                          )),
                  const SizedBox(height: 8),
                  Text("Create The",
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 4),
                  Text("Custom Tailored Mystery Murder Game Script",
                      style: Theme.of(context).textTheme.titleLarge),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Any ideas!",
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                          onChanged: (value) =>
                              scriptProvider.updatePrompt(value),
                          onSubmitted: (value) {
                            scriptProvider.sendPrompt();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TravelWrapper(),
                              ),
                            );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          scriptProvider.sendPrompt();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CharacterDetails(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Spacer(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
