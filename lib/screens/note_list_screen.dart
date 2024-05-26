import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/note_edit_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/note_services.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: const NoteList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NoteEditScreen(),
            ),
          ); //push bs balek lagi, pushReplacement dbs balek
         
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  Future<void> _launchMaps(double latitude, double longitude) async {
    Uri googleUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    try {
      await launchUrl(googleUrl);
    } catch (e) {
      print('Could not open the map: $e');
      // Optionally, show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: NoteService.getNoteList(),
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
                          builder: (context) => NoteEditScreen(note: document),
                        ),
                      );
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return NoteDialog(note: document);
                      //   },
                      // );
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
                          subtitle: Text(document.description),
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
                                              NoteService.deleteNote(document)
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