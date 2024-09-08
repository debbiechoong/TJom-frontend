import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/onboarding/restaurant_address.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantImage extends StatefulWidget {
  const RestaurantImage({super.key});

  @override
  State<RestaurantImage> createState() => _RestaurantImageState();
}

class _RestaurantImageState extends State<RestaurantImage> {
  List<XFile> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  Future<void> _pickImages() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage();
    setState(() {
      _images = selectedImages;
    });
  }

  Future<List<String>> _uploadImages() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print("User ID not found in SharedPreferences");
      throw Exception("User ID not found in SharedPreferences");
    }

    List<String> imageUrls = [];
    for (var i = 0; i < _images.length; i++) {
      var image = _images[i];
      String fileName = "$userId${i + 1}";
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('restaurant/images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
      TaskSnapshot taskSnapshot = await uploadTask;
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  @override
  Widget build(BuildContext context) {
    final onBoardingProvider =
        Provider.of<RestaurantOnboardingProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(height: 16),
              Text(
                "Restaurant Images",
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Text("Please upload your images",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImages,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: _images.isEmpty
                      ? Center(
                          child: Text(
                            "Tap to upload images",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                          ),
                        )
                      : M3Carousel(
                          isLocal: true,
                          visible: _images.length,
                          slideAnimationDuration: 300, // milliseconds
                          titleFadeAnimationDuration: 200, // milliseconds
                          children: [
                            ..._images.map((img) {
                              return {"image": img.path, "title": ""};
                            }),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 32),
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_images.isNotEmpty) {
                              setState(() {
                                _isLoading = true; // Start loading
                              });
                              List<String> uploadedUrls = await _uploadImages();
                              onBoardingProvider.setImages(uploadedUrls);

                              // Proceed to the next screen
                              if (mounted) {
                                setState(() {
                                  _isLoading = false; // Stop loading
                                });
                                onBoardingProvider.setImages(uploadedUrls);

                                // Proceed to the next screen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RestaurantAddress(),
                                  ),
                                );
                              }
                            }
                          },
                    child: _isLoading
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                "Loading...",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                              ),
                            ],
                          )
                        : Text("Next",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    )),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
