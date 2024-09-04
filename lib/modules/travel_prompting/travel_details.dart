import 'package:flutter/material.dart';
import 'package:jejom/providers/onboarding_provider.dart';
import 'package:jejom/providers/travel_provider.dart';
import 'package:jejom/utils/loading_screen.dart';
import 'package:provider/provider.dart';

class TravelDetails extends StatefulWidget {
  const TravelDetails({super.key});

  @override
  State<TravelDetails> createState() => _TravelDetailsState();
}

class _TravelDetailsState extends State<TravelDetails> {
  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);

    FocusManager.instance.primaryFocus?.unfocus();

    return travelProvider.isLoading
        ? const Center(child: LoadingWidget())
        : SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 80),
              IconButton(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    // size: 24,
                  )),
              const SizedBox(height: 16),
              travelProvider.isDestination
                  ? _buildDestination(travelProvider)
                  : const SizedBox(),
              travelProvider.isDuration
                  ? _buildDuration(travelProvider)
                  : const SizedBox(),
              travelProvider.isBudget
                  ? _buildBudget(travelProvider)
                  : const SizedBox(),
              Row(
                children: [
                  const Spacer(),
                  FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primaryContainer),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    onPressed: () => travelProvider.sendTravelDetails(context),
                    child: Text("I'm in!",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            )),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ]),
          );
  }

  Widget _buildDestination(TravelProvider travelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          onChanged: (value) => travelProvider.updateDestination(value),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildDuration(TravelProvider travelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Duration",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Text(
                "${travelProvider.startDate.toIso8601String().substring(0, 10)} - ${travelProvider.endDate.toIso8601String().substring(0, 10)}"),
            const Spacer(),
            IconButton(
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  lastDate: DateTime(2026),
                  firstDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    travelProvider.startDate = picked.start;
                    travelProvider.endDate = picked.end;
                    //below have methods that runs once a date range is picked
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
            ),
          ],
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildBudget(TravelProvider travelProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          decoration: InputDecoration(
            hintText: "xxx + any currency!",
            prefixIcon: const Icon(Icons.currency_pound_rounded),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) => travelProvider.updateBudget(value),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
