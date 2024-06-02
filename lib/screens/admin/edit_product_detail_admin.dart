import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../services/song_service.dart';

class EditProductDetail extends StatefulWidget {
  const EditProductDetail({Key? key}) : super(key: key);

  @override
  State<EditProductDetail> createState() => _EditProductDetailState();
}

class _EditProductDetailState extends State<EditProductDetail> {
  File? _image;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _arangementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _creatorController = TextEditingController();

  get imageUrl => null;
  
  get isFavorite => null;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _saveData() async {
    try {
      // Create song object
      Song newSong = Song(
        id: '',
        songTitle: _titleController.text,
        creator: _creatorController.text,
        genre: _genreController.text,
        description: _descriptionController.text,
        imageSong: imageUrl,
        price: double.parse(_priceController.text),
        arangement: _arangementController.text,
        isFavorite: isFavorite ?? false,
        rating: 0.0,
        
      );

      await SongService.addSong(newSong, _image);

      _titleController.clear();
      _creatorController.clear();
      _genreController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _arangementController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration:  BoxDecoration(
                    gradient: LinearGradient(
                      colors: themeProvider.themeMode().gradientColors!,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                Positioned(
                  top: 25.0,
                  left: 16.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      'images/arrowback.png',
                      width: 32.0,
                      height: 32.0,
                      color: themeProvider.themeMode().switchColor!,
                    ),
                  ),
                ),
                Positioned(
                  top: 75.0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200.0,
                        decoration: BoxDecoration(
                          color: themeProvider.themeMode().switchBgColor!,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: _image == null
                              ? Image.asset(
                                  'images/plus.png',
                                  width: 70.0,
                                  height: 70.0,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    _image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 260.0,
                  left: 16.0,
                  right: 16.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _titleController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Title...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Bayon',
                                fontSize: 25,
                              ),
                            ),
                            TextField(
                              controller: _creatorController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Creator...',
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Bayon',
                                color: Color(0xFFFF8A00),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 159, 130, 101),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Genre: ',
                                      style: TextStyle(
                                        fontFamily: 'Bayon',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _genreController,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Masukkan Genre...',
                                          hintStyle:
                                              TextStyle(color: Colors.white),
                                        ),
                                        style: const TextStyle(
                                          fontFamily: 'Bayon',
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 159, 130, 101),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Masukkan Deskripsi...',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Bayon',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  maxLines: 6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 159, 130, 101),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _arangementController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Masukkan Aransemen...',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Bayon',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  maxLines: 6,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 159, 130, 101),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _priceController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Masukkan Harga...',
                                    hintStyle: TextStyle(color: Colors.white),
                                  ),
                                  style: const TextStyle(
                                    fontFamily: 'Bayon',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 14.0,
                  left: 60.0,
                  right: 60.0,
                  child: GestureDetector(
                    onTap: _saveData,
                    child: Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 145, 49),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 4),
                            blurRadius: 8.0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      ),
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