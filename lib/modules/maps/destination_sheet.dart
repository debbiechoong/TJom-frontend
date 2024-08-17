import 'package:flutter/material.dart';
import 'package:jejom/models/interest_destination.dart';
import 'package:jejom/utils/base_draggable.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DestinationBottomSheet extends StatefulWidget {
  DestinationBottomSheet({
    super.key,
    required this.destinationSheetKey,
    required this.destinationSheetController,
    required this.openSheet,
    required this.closeSheet,
    this.pickedDestination,
  });

  final GlobalKey destinationSheetKey;
  final DraggableScrollableController destinationSheetController;
  final Function openSheet;
  final Function closeSheet;
  InterestDestination? pickedDestination;

  @override
  State<DestinationBottomSheet> createState() => _DestinationBottomSheetState();
}

class _DestinationBottomSheetState extends State<DestinationBottomSheet> {
  late ThemeData themeData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.destinationSheetController.removeListener(() {});
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    themeData = Theme.of(context);
    super.didChangeDependencies();
  }

  Future<void> launchGoogleMaps(
      double destinationLatitude, double destinationLongitude) async {
    final uri = Uri(
        scheme: "google.navigation",
        // host: '"0,0"',  {here we can put host}
        queryParameters: {'q': '$destinationLatitude, $destinationLongitude'});
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('An error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseDraggableSheet(
        sheetKey: widget.destinationSheetKey,
        controller: widget.destinationSheetController,
        minChildSize: 120 / MediaQuery.of(context).size.height,
        child: SliverList(
            delegate: SliverChildListDelegate([
          Center(
            child: Container(
              width: 64,
              height: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: themeData.colorScheme.outlineVariant,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Expanded(
                  child: Text(
                widget.pickedDestination?.name ?? "",
                style: Theme.of(context).textTheme.titleLarge,
              )),
              IconButton(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close),
                  onPressed: () => {}),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FilledButton.icon(
                onPressed: () {
                  launchGoogleMaps(widget.pickedDestination!.lat,
                      widget.pickedDestination!.long);
                },
                icon: const Icon(Icons.directions),
                label: Text('Navigate',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary)),
              ),
              const SizedBox(width: 16),

              // BlocBuilder<FavDestinationBloc, FavDestinationState>(
              //   bloc: favDestinationBloc,
              //   builder: (context, favState) {
              //     if (favState is FavDestinationLoaded) {
              //       return favState.favDestinationList
              //               .where((element) =>
              //                   element.name == state.pickedDestination.name)
              //               .isNotEmpty
              //           ? FilledButton.tonalIcon(
              //               onPressed: () => {
              //                 deleteFavDestination(favState, state),
              //               },
              //               icon: const Icon(Icons.bookmark_added),
              //               label: Text('Saved',
              //                   style: Theme.of(context).textTheme.labelLarge),
              //             )
              //           : FilledButton.tonalIcon(
              //               onPressed: () => {
              //                 saveFavDestination(state),
              //               },
              //               icon: const Icon(Icons.bookmark_add_outlined),
              //               label: Text('Save',
              //                   style: Theme.of(context).textTheme.labelLarge),
              //             );
              //     }
              //     return const SizedBox();
              //   },
              // ),
            ],
          ),
          const SizedBox(height: 16),
          widget.pickedDestination == null
              ? const SizedBox()
              : SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: M3Carousel(
                    slideAnimationDuration: 300, // milliseconds
                    titleFadeAnimationDuration: 200, // milliseconds
                    children: [
                      ...widget.pickedDestination!.imageUrl.map((img) {
                        return {"image": img, "title": ""};
                      }),
                    ],
                  ),
                ),
          // SizedBox(height: state.pickedDestination.imageUrl != null ? 16 : 0),
          // state.pickedDestination.imageUrl != null
          //     ? Container(
          //         height: size.screenSize.width * 0.4,
          //         width: size.screenSize.width * 0.4,
          //         alignment: Alignment.centerLeft,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(16),
          //             color: themeData.colorScheme.surfaceVariant
          //                 .withOpacity(0.5)),
          //         child: Image.network(
          //           state.pickedDestination.imageUrl!,
          //           fit: BoxFit.cover,
          //         ),
          //       )
          //     : const SizedBox(),
          // Container(
          //   height: size.screenSize.width * 0.4,
          //   width: size.screenSize.width * 0.4,
          //   alignment: Alignment.centerLeft,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(16),
          //       color: colors.surfaceVariant.withOpacity(0.5)),
          //   child: Image.asset(
          //     'assets/images/logo.png',
          //   ),
          // ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            widget.pickedDestination == null
                ? "No description"
                : widget.pickedDestination!.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            widget.pickedDestination == null
                ? "No address"
                : "Address: ${widget.pickedDestination!.address}",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     const Icon(Icons.location_on),
          //     const SizedBox(width: 8),
          //     Flexible(
          //       child: Text(
          //         state.pickedDestination.address == ""
          //             ? "No address"
          //             : state.pickedDestination.address,
          //         style: Theme.of(context).textTheme.bodyLarge,
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 24),
        ])));
  }
}
