import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jejom/modules/restaurant/onboarding/restaurant_address.dart';
import 'package:jejom/providers/restaurant/restaurant_onboarding_provider.dart';
import 'package:jejom/utils/m3_carousel.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

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
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0E6FF),
                  Color(0xFFD5E6F3),
                ],
              ),
            ),
          ),
          
          // Abstract design elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.1),
              ),
            ),
          ),
          
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.1),
              ),
            ),
          ),
          
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: const Icon(Icons.arrow_back, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Restaurant Images",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Upload photos to showcase your restaurant",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Image upload section
                    GestureDetector(
                      onTap: _pickImages,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            width: double.infinity,
                            height: 280,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: _images.isEmpty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 60,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Tap to upload images",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: M3Carousel(
                                      isLocal: true,
                                      visible: _images.length,
                                      slideAnimationDuration: 300,
                                      titleFadeAnimationDuration: 200,
                                      children: [
                                        ..._images.map((img) {
                                          return {"image": img.path, "title": ""};
                                        }),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Next Button
                    Center(
                      child: GestureDetector(
                        onTap: _isLoading
                          ? null
                          : () async {
                              if (_images.isNotEmpty) {
                                setState(() {
                                  _isLoading = true;
                                });
                                List<String> uploadedUrls = await _uploadImages();
                                onBoardingProvider.setImages(uploadedUrls);

                                if (mounted) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => const RestaurantAddress(),
                                    ),
                                  );
                                }
                              }
                            },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 60),
                          decoration: BoxDecoration(
                            color: _isLoading ? Colors.grey : Colors.black87,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: _isLoading
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Uploading...",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
