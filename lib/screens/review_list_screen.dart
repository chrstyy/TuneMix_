import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gracieusgalerij/screens/review_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/review_services.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 24,
                  ),
                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0, 0),
                      child: Text(
                        'Reviews',
                        style: TextStyle(fontFamily: 'Bayon', fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                thickness: 3,
                color: Colors.black,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: const ReviewList(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReviewEditScreen(),
                ),
              ); //push bs balek lagi, pushReplacement dbs balek
            },
            tooltip: 'Add Review',
            backgroundColor: Colors.teal,
            shape: const CircleBorder(),
            elevation: 20,
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  const ReviewList({Key? key});

  Future<void> _launchMaps(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    try {
      await launchUrl(googleUrl);
    } catch (e) {
      print('Could not open the map: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ReviewService.getReviewList(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          default:
            return ListView(
              padding: const EdgeInsets.all(10),
              children: snapshot.data!.map((document) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 105, 64, 7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document.title,
                              style: const TextStyle(
                                fontFamily: 'Bayon',
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'created/updated at',
                              style: TextStyle(
                                fontFamily: 'Battambang',
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: document.imageUrl != null &&
                                        Uri.parse(document.imageUrl!).isAbsolute
                                    ? DecorationImage(
                                        image: NetworkImage(document.imageUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      Text(
                                        'Pick location...',
                                        style: TextStyle(
                                          fontFamily: 'Readex Pro',
                                          fontSize: 10,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.white,
                                  ),
                                  onSelected: (String value) {
                                    if (value == 'edit') {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ReviewEditScreen(
                                                  review: document),
                                        ),
                                      );
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: Text(
                                                'Are you sure want to delete this \'${document.title}\' ?'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('Delete'),
                                                onPressed: () {
                                                  ReviewService.deleteReview(
                                                          document)
                                                      .whenComplete(() =>
                                                          Navigator.of(context)
                                                              .pop());
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('Delete'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                RatingBar.builder(
                                  initialRating: document.rating ?? 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Color.fromARGB(255, 10, 223, 205),
                                  ),
                                  unratedColor:
                                      const Color.fromARGB(255, 255, 225, 225),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    // Update rating in your data model or wherever necessary
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 1,
                          color: Colors.white,
                        ),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: document.imageUrl != null &&
                                    Uri.parse(document.imageUrl!).isAbsolute
                                ? DecorationImage(
                                    image: NetworkImage(document.imageUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                        Text(
                          document.comment,
                          style: const TextStyle(
                            fontFamily: 'Basic',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
        }
      },
    );
  }
}
