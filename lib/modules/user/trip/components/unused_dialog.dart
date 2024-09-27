
  // Future showAnimatedDialog(BuildContext context,
  //     {IconData? icon,
  //     required String title,
  //     required String desc,
  //     required String buttonText,
  //     required Function() onPressed,
  //     required String prompt}) async {
  //   final colors = Theme.of(context).colorScheme;
  //   // final tripProvider = Provider.of<TripProvider>(context);

  //   List<Widget> dialogWidgets = [
  //     Icon(
  //       icon,
  //       color: colors.primary,
  //       size: 32,
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.only(top: 16.0),
  //       child: Text(
  //         title,
  //         style: Theme.of(context).textTheme.headlineSmall,
  //         textAlign: TextAlign.center,
  //       ),
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.only(top: 16.0),
  //       child: Text(
  //         desc,
  //         style: Theme.of(context).textTheme.bodyMedium,
  //       ),
  //     ),
  //     Padding(
  //       padding: const EdgeInsets.only(top: 16.0),
  //       child: Material(
  //         child: TextField(
  //           keyboardType: TextInputType.multiline,
  //           maxLines: null,
  //           autofocus: true,
  //           decoration: InputDecoration(
  //             hintText: "Enter your prompt here",
  //             border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(16),
  //             ),
  //           ),
  //           onChanged: (value) => setState(() {
  //             prompt = value;
  //           }),
  //         ),
  //       ),
  //     ),
  //   ];
  //   return showGeneralDialog(
  //       barrierColor: Colors.black.withOpacity(0.5),
  //       transitionBuilder: (context, a1, a2, child) {
  //         return AnimatedOpacity(
  //           opacity: a1.value,
  //           duration: const Duration(milliseconds: 200),
  //           child: Center(
  //             child: Container(
  //               height: 312,
  //               alignment: Alignment.topCenter,
  //               child: AnimatedContainer(
  //                 height: a1.value * 312,
  //                 width: MediaQuery.of(context).size.width * 0.8,
  //                 decoration: BoxDecoration(
  //                   color: colors.background,
  //                   borderRadius: BorderRadius.circular(24),
  //                 ),
  //                 duration: const Duration(milliseconds: 500),
  //                 curve: EMPHASIZED_DECELERATE,
  //                 child: Align(
  //                   alignment: Alignment.topCenter,
  //                   child: Stack(
  //                     fit: StackFit.expand,
  //                     children: [
  //                       Padding(
  //                         padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //                         child: SingleChildScrollView(
  //                           child: Column(
  //                             children: [
  //                               const SizedBox(height: 24),
  //                               ...dialogWidgets.asMap().entries.map((e) {
  //                                 int index = e.key;
  //                                 Widget widget = e.value;
  //                                 return AnimatedOpacity(
  //                                   duration: Duration(
  //                                       milliseconds: 500 + index * 1000),
  //                                   curve: EMPHASIZED_DECELERATE,
  //                                   opacity: a1.value,
  //                                   child: widget,
  //                                 );
  //                               })
  //                             ],
  //                           ),
  //                         ),
  //                       ),
  //                       Positioned(
  //                         bottom: 24,
  //                         right: 24,
  //                         width: MediaQuery.of(context).size.width * 0.8 - 48,
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.end,
  //                           children: [
  //                             FilledButton(
  //                               onPressed: () {
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: Text(
  //                                 'Cancel',
  //                                 style: Theme.of(context)
  //                                     .textTheme
  //                                     .labelLarge!
  //                                     .copyWith(
  //                                       color: colors.onPrimary,
  //                                     ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 16),
  //                             FilledButton(
  //                               style: ButtonStyle(
  //                                 backgroundColor: MaterialStateProperty.all(
  //                                     Theme.of(context)
  //                                         .colorScheme
  //                                         .primaryContainer),
  //                                 visualDensity:
  //                                     VisualDensity.adaptivePlatformDensity,
  //                               ),
  //                               onPressed: () {
  //                                 onPressed();
  //                                 Navigator.of(context).pop();
  //                               },
  //                               child: Text(
  //                                 buttonText,
  //                                 style: Theme.of(context)
  //                                     .textTheme
  //                                     .labelLarge!
  //                                     .copyWith(
  //                                       color: colors.onPrimary,
  //                                     ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       transitionDuration: const Duration(milliseconds: 200),
  //       barrierDismissible: true,
  //       barrierLabel: '',
  //       context: context,
  //       pageBuilder: (context, animation1, animation2) {
  //         return const SizedBox();
  //       });
  // }