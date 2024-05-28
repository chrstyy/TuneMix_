import 'package:flutter/material.dart';

class EditGenre extends StatefulWidget {
  @override
  _EditGenreState createState() => _EditGenreState();
}

class _EditGenreState extends State<EditGenre> {
  final TextEditingController _genreController = TextEditingController();

  void _addGenre() {
    // Here you can handle the genre addition logic
    // For example, updating the database or state
    String genreName = _genreController.text.trim();
    if (genreName.isNotEmpty) {
      // Add genre to database or perform other actions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Genre "$genreName" added')),
      );
      _genreController.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a genre name')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Genre'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _genreController,
              decoration: InputDecoration(
                labelText: 'Genre Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addGenre,
              child: Text('Add Genre'),
            ),
          ],
        ),
      ),
    );
  }
}
