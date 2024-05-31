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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  File? _imageFile;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _titleController.text = widget.review!.title;
      _commentController.text = widget.review!.comment;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F4E1), Color(0xFFAF8F6F)],
            stops: [0, 1],
            begin: AlignmentDirectional(0, -1),
            end: AlignmentDirectional(0, 1),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 24,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Text(
                          widget.review == null
                              ? 'Add Reviews'
                              : 'Edit Reviews',
                          style: const TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 3,
                  color: Colors.black,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 84, 51, 16),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Title : ',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        TextField(
                          controller: _titleController,
                          style: const TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Comment : ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        TextField(
                          controller: _commentController,
                          style: const TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Text(
                            'Image : ',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _imageFile != null
                            ? AspectRatio(
                                aspectRatio: 16 / 9,
                                child:
                                    Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                            : (widget.review?.imageUrl != null &&
                                    Uri.parse(widget.review!.imageUrl!)
                                        .isAbsolute
                                ? Image.network(widget.review!.imageUrl!,
                                    fit: BoxFit.cover)
                                : Container()),
                        TextButton(
                          onPressed: _pickImage,
                          child: const Text(
                            'Pick Image',
                          ),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                  imageUrl = await ReviewService.uploadImage(
                                      _imageFile!);
                                } else {
                                  imageUrl = widget.review?.imageUrl;
                                }
                                Review review = Review(
                                  id: widget.review?.id,
                                  title: _titleController.text,
                                  comment: _commentController.text,
                                  imageUrl: imageUrl,
                                  latitude: _currentPosition?.latitude,
                                  longitude: _currentPosition?.longitude,
                                  createdAt: widget.review?.createdAt,
                                );

                                if (widget.review == null) {
                                  ReviewService.addReview(review).whenComplete(
                                      () => Navigator.of(context).pop());
                                } else {
                                  ReviewService.updateReview(review)
                                      .whenComplete(
                                          () => Navigator.of(context).pop());
                                }
                              },
                              child: Text(
                                  widget.review == null ? 'Add' : 'Update'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
