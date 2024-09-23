import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:jejom/modules/restaurant/all_scripts/script_details.dart';
import 'package:jejom/providers/restaurant/script_restaurant_provider.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/glass_container.dart';
import 'package:provider/provider.dart';

class ResScripts extends StatefulWidget {
  const ResScripts({super.key});

  @override
  State<ResScripts> createState() => _ResScriptsState();
}

class _ResScriptsState extends State<ResScripts> {
  @override
  Widget build(BuildContext context) {
    final scriptGameProvider = Provider.of<ScriptRestaurantProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                  )),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/logo.webp",
                  height: 200,
                  scale: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "All Script Game",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                "List of script game generated",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              scriptGameProvider.games.isEmpty
                  ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          "No script game generated yet",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ))
                  : AnimationLimiter(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: scriptGameProvider.games.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 375),
                              child: SlideAnimation(
                                curve: EMPHASIZED_DECELERATE,
                                child: FadeInAnimation(
                                  curve: EMPHASIZED_DECELERATE,
                                  child: GlassContainer(
                                    padding: 16,
                                    marginBottom: 16,
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                scriptGameProvider
                                                    .games[index].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                "Duration: ${scriptGameProvider.games[index].duration}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            scriptGameProvider.selectGame(
                                                scriptGameProvider
                                                    .games[index]);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const ScriptDetailsPage(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 64,
                                            height: 64,
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primaryContainer,
                                                width: 2,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(32),
                                            ),
                                            child: Transform.rotate(
                                              angle: 1.5708 / 2,
                                              child: const Icon(
                                                  Icons.arrow_upward_rounded),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
