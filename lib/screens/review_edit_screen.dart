import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gracieusgalerij/models/review.dart';
import 'package:gracieusgalerij/services/location_services.dart';
import 'package:gracieusgalerij/services/review_services.dart';
import 'package:image_picker/image_picker.dart';

class ReviewEditScreen extends StatefulWidget {
  final Review? review;
  const ReviewEditScreen({super.key, this.review});

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  final TextEditingController _productNController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _productNController.text = widget.review!.productName;
      _commentController.text = widget.review!.comment;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation() async {
    final currentPosition = await LocationService.getCurrentPosition();
    setState(() {
      _currentPosition = currentPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.review == null ? 'Add Review' : 'Update Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Name : ',
                textAlign: TextAlign.start,
              ),
              TextField(
                controller: _productNController,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Comment : ',
                ),
              ),
              TextField(
                controller: _commentController,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text('Image: '),
              ),
              _imageFile != null
                  ? AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.file(_imageFile!, fit: BoxFit.cover),
                    )
                  : (widget.review?.imageUrl != null &&
                          Uri.parse(widget.review!.imageUrl!).isAbsolute
                      ? Image.network(widget.review!.imageUrl!,
                          fit: BoxFit.cover)
                      : Container()),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              TextButton(
                onPressed: _pickLocation,
                child: const Text('Get Current Location'),
              ),
              Text('LAT: ${_currentPosition?.latitude ?? ""}'),
              Text('LNG: ${_currentPosition?.longitude ?? ""}'),
              // Text('ADDRESS: ${_currentAddress ?? ""}'),

              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      String? imageUrl;
                      if (_imageFile != null) {
                        imageUrl = await ReviewService.uploadImage(_imageFile!);
                      } else {
                        imageUrl = widget.review?.imageUrl;
                      }
                      Review review = Review(
                        id: widget.review?.id,
                        productName: _productNController.text,
                        comment: _commentController.text,
                        imageUrl: imageUrl,
                        latitude: _currentPosition?.latitude,
                        longitude: _currentPosition?.longitude,
                        createdAt: widget.review?.createdAt,
                      );

                      if (widget.review == null) {
                        ReviewService.addReview(review)
                            .whenComplete(() => Navigator.of(context).pop());
                      } else {
                        ReviewService.updateReview(review)
                            .whenComplete(() => Navigator.of(context).pop());
                      }
                    },
                    child: Text(widget.review == null ? 'Add' : 'Update'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
