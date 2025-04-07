import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:jejom/models/flight_info.dart';
import 'package:jejom/models/trip.dart';
import 'package:jejom/utils/constants/curve.dart';
import 'package:jejom/utils/theme/app_theme.dart';
import 'package:jejom/utils/widgets/app_back_button.dart';
import 'package:jejom/utils/widgets/glass_container.dart';
import 'package:jejom/utils/widgets/section_header.dart';

class FlightsSection extends StatefulWidget {
  const FlightsSection({super.key, required this.trip});

  final Trip trip;

  @override
  State<FlightsSection> createState() => _FlightsSectionState();
}

class _FlightsSectionState extends State<FlightsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isDeparture = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Trip trip = widget.trip;

    if (trip.flight.departureFlight?.airlineLogo == null) {
      return Scaffold(
        body: Stack(
          children: [
            // Gradient background
            Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.travelGradient,
              ),
            ),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.paddingLarge),
                    AppBackButton(
                      onTap: () => Navigator.of(context).pop(),
                      hasBackground: true,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      "No flights available for this trip.",
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppTheme.textDark.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    
    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.travelGradient,
            ),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppTheme.paddingLarge),
                    AppBackButton(
                      onTap: () => Navigator.of(context).pop(),
                      hasBackground: true,
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    SectionHeader(
                      title: "Flights",
                      icon: Icons.flight,
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Text(
                      "KRW ${trip.flight.priceTotal}",
                      style: AppTheme.displayMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.travelPrimary,
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingMedium),
                    Text(
                      "There would be ${(trip.flight.departureFlight?.flights?.length ?? 0) + (trip.flight.returnFlight?.flights?.length ?? 0)} flights for this trip",
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textDark.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: AppTheme.paddingSmall),
                    Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                          primary: AppTheme.travelPrimary,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        onTap: (value) {
                          bool temp = value == 0 ? true : false;
                          setState(() {
                            isDeparture = temp;
                          });
                        },
                        labelStyle: AppTheme.labelMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        indicatorColor: AppTheme.travelPrimary,
                        tabs: const <Widget>[
                          Tab(
                            text: "Departure",
                            icon: Icon(Icons.flight_takeoff),
                          ),
                          Tab(
                            text: "Return",
                            icon: Icon(Icons.flight_land),
                          ),
                        ],
                      ),
                    ),
                    trip.flight.departureFlight?.airlineLogo == null ||
                            trip.flight.departureFlight?.flights == null
                        ? Text(
                            "No flights available for this trip.",
                            style: AppTheme.bodyLarge.copyWith(
                              color: AppTheme.textDark.withOpacity(0.8),
                            ),
                          )
                        : const SizedBox(),
                    isDeparture
                        ? AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  trip.flight.departureFlight?.flights?.length ?? 0,
                              itemBuilder: (context, index) {
                                return _buildFlightCard(
                                    trip.flight.departureFlight!.flights![index],
                                    index);
                              },
                            ),
                          )
                        : AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  trip.flight.returnFlight?.flights?.length ?? 0,
                              itemBuilder: (context, index) {
                                return _buildFlightCard(
                                    trip.flight.returnFlight!.flights![index], index);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Flights flight, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        curve: EMPHASIZED_DECELERATE,
        child: FadeInAnimation(
          curve: EMPHASIZED_DECELERATE,
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.paddingLarge, top: AppTheme.paddingMedium),
            child: GlassContainer(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              backgroundColor: AppTheme.travelPrimary.withOpacity(0.05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingSmall, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.travelPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        ),
                        child: Text(
                          flight.travelClass ?? "",
                          style: AppTheme.labelMedium.copyWith(
                            color: AppTheme.travelPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        flight.departureAirport?.id ?? "",
                        style: AppTheme.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: AppTheme.paddingSmall),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.flight,
                          color: AppTheme.travelPrimary,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppTheme.paddingSmall),
                      Text(
                        flight.arrivalAirport?.id ?? "",
                        style: AppTheme.displaySmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  const Divider(),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                        child: Image.network(
                          flight.airlineLogo ?? '',
                          width: 32,
                          height: 32,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.error, color: AppTheme.travelPrimary),
                        ),
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                      Text(
                        "${flight.airline ?? 'Unknown Airline'} - ${flight.flightNumber ?? 'N/A'}",
                        style: AppTheme.labelLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                    ),
                    padding: const EdgeInsets.all(AppTheme.paddingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flight_takeoff, size: 16, color: AppTheme.travelPrimary),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Text(
                              DateFormat('kk:mm a').format(DateTime.tryParse(flight.departureAirport?.time ?? '') ?? DateTime.now()),
                              style: AppTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Text(
                              flight.departureAirport?.name ?? 'Unknown Airport',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: AppTheme.paddingSmall),
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.paddingSmall, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadiusSmall),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.access_time, size: 12, color: AppTheme.textDark.withOpacity(0.7)),
                                const SizedBox(width: 4),
                                Text(
                                  'Travel Time: ${flight.duration ?? 'Unknown'}',
                                  style: AppTheme.labelSmall.copyWith(
                                    color: AppTheme.textDark.withOpacity(0.7),
                                  ),
                                ),
                                if (flight.overnight ?? false) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'Overnight',
                                      style: AppTheme.labelSmall.copyWith(
                                        color: Colors.red.shade700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.flight_land, size: 16, color: AppTheme.travelPrimary),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Text(
                              DateFormat('kk:mm a').format(DateTime.tryParse(flight.arrivalAirport?.time ?? '') ?? DateTime.now()),
                              style: AppTheme.labelLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: AppTheme.paddingSmall),
                            Text(
                              flight.arrivalAirport?.name ?? 'Unknown Airport',
                              style: AppTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
