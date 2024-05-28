import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProductDetail extends StatefulWidget {
  const EditProductDetail({Key? key}) : super(key: key);

  @override
  State<EditProductDetail> createState() => _EditProductDetailState();
}

class _EditProductDetailState extends State<EditProductDetail> {
  File? _image;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _creatorController = TextEditingController();
  TextEditingController _genreController = TextEditingController();
  TextEditingController _lyricsController = TextEditingController();

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
    String imageUrl = '';

    if (_image != null) {
      // Upload image to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('product_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      await storageRef.putFile(_image!);
      imageUrl = await storageRef.getDownloadURL();
    }

    // Save data to Firestore
    await FirebaseFirestore.instance.collection('products').add({
      'title': _titleController.text,
      'creator': _creatorController.text,
      'genre': _genreController.text,
      'lyrics': _lyricsController.text,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data berhasil disimpan!')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gagal menyimpan data: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF8F4E1),
                    Color(0xFFAF8F6F),
                  ],
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
                      color: Color(0xFF543310),
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
                                
                    width : double.infinity,
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
                    height: 370.0,
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
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Title...',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            fontSize: 25,
                          ),
                        ),
                        TextField(
                          controller: _creatorController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Creator...',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontFamily: 'Bayon',
                            color: Color(0xFFFF8A00),
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 159, 130, 101),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                Text(
                                  'Genre: ',
                                  style: TextStyle(
                                    fontFamily: 'Bayon',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    controller: _genreController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Masukkan Genre...',
                                      hintStyle: TextStyle(color: Colors.white),
                                    ),
                                    style: TextStyle(
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
                        SizedBox(height: 14),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 159, 130, 101),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _lyricsController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Masukkan Aransemen atau Lirik...',
                                hintStyle: TextStyle(color: Colors.white),
                              ),
                              style: TextStyle(
                                fontFamily: 'Bayon',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              maxLines: 6,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 8.0,
                      ),
                    ],
                  ),
                  child: Center(
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
    );
  }
}

