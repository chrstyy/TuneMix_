import 'package:flutter/material.dart';
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
  const ReviewList({super.key});

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
              padding: const EdgeInsets.only(bottom: 80),
              children: snapshot.data!.map((document) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ReviewEditScreen(review: document),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        document.imageUrl != null &&
                                Uri.parse(document.imageUrl!).isAbsolute
                            ? ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                child: Image.network(
                                  document.imageUrl!,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  height: 150,
                                ),
                              )
                            : Container(),
                        ListTile(
                          title: Text(document.title),
                          subtitle: Text(document.comment),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.map),
                                onPressed: document.latitude != null &&
                                        document.longitude != null
                                    ? () {
                                        _launchMaps(document.latitude!,
                                            document.longitude!);
                                      }
                                    : null, // Disable the button if latitude or longitude is null
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Yakin ingin menghapus data \'${document.title}\' ?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Hapus'),
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
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                            ],
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
