import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../models/song.dart';
import '../../services/song_service.dart';

class EditProductDetail extends StatefulWidget {
  const EditProductDetail({super.key});

  @override
  State<EditProductDetail> createState() => _EditProductDetailState();
}

class _EditProductDetailState extends State<EditProductDetail> {
  File? _image;
  int yearMade = DateTime.now().year;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _arangementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _creatorController = TextEditingController();

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
        yearMade: yearMade,
        imageSong: '', // imageUrl seharusnya ditentukan
        price: double.parse(_priceController.text),
        arangement: _arangementController.text,
        isFavorite: false, // isFavorite seharusnya ditentukan
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: themeProvider.themeMode().gradientColors!,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200.0,
                      decoration: BoxDecoration(
                        color: themeProvider.themeMode().switchBgColor!,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _image == null
                            ? Image.asset(
                                'images/plus.png',
                                width: 70.0,
                                height: 70.0,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(10),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode().switchBgColor2!,
                    borderRadius: BorderRadius.circular(10),
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
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          fontSize: 25,
                          color: themeProvider.themeMode().switchColor!,
                        ),
                      ),
                      TextField(
                        controller: _creatorController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Creator...',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          color: themeProvider.themeMode().switchColor!,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: themeProvider.themeMode().switchBgColor!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Text(
                                'Genre : ',
                                style: TextStyle(
                                  fontFamily: 'Bayon',
                                  color: themeProvider.themeMode().thumbColor!,
                                  fontSize: 17,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _genreController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '...',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Bayon',
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontFamily: 'Bayon',
                                    color:
                                        themeProvider.themeMode().thumbColor!,
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
                          color: themeProvider.themeMode().switchBgColor!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Masukkan Deskripsi...',
                              hintStyle: TextStyle(
                                fontFamily: 'Bayon',
                                color: themeProvider.themeMode().thumbColor!,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              color: themeProvider.themeMode().thumbColor!,
                              fontSize: 16,
                            ),
                            maxLines: 6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      // Container(
                      //   height: 150,
                      //   width: double.infinity,
                      //   decoration: BoxDecoration(
                      //     color: themeProvider.themeMode().switchBgColor!,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(10),
                      //     child: TextField(
                      //       controller: _yearMadeController,
                      //       decoration: InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: 'Masukkan Tahun Rilis...',
                      //         hintStyle: TextStyle(
                      //           fontFamily: 'Bayon',
                      //           color: themeProvider.themeMode().thumbColor!,
                      //         ),
                      //       ),
                      //       style: TextStyle(
                      //         fontFamily: 'Bayon',
                      //         color: themeProvider.themeMode().thumbColor!,
                      //         fontSize: 16,
                      //       ),
                      //       maxLines: 6,
                      //     ),
                      //   ),
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Selected Year: $yearMade',
                            style: const TextStyle(
                              fontFamily: 'Bayon',
                              color: Colors.brown,
                              fontSize: 16,
                            )
                            ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.brown,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Select Year'),
                                    content: Container(
                                      width: double.maxFinite,
                                      height: 400, // Ensuring height to fit YearPicker
                                      child: YearPicker(
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime(2050),
                                        selectedDate: DateTime.now(),
                                        onChanged: (DateTime dateTime) {
                                          setState(() {
                                            yearMade = dateTime.year;
                                          });
                                          Navigator.pop(context); // Close the dialog
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: const Text(
                              'Pick Year',
                              style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: themeProvider.themeMode().switchBgColor!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: _arangementController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Masukkan Aransemen...',
                              hintStyle: TextStyle(
                                fontFamily: 'Bayon',
                                color: themeProvider.themeMode().thumbColor!,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              color: themeProvider.themeMode().thumbColor!,
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
                          color: themeProvider.themeMode().switchBgColor!,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Masukkan Harga...',
                              hintStyle: TextStyle(
                                fontFamily: 'Bayon',
                                color: themeProvider.themeMode().thumbColor!,
                              ),
                            ),
                            style: TextStyle(
                              fontFamily: 'Bayon',
                              color: themeProvider.themeMode().thumbColor!,
                              fontSize: 16,
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _saveData,
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 46, 145, 49),
                        borderRadius: BorderRadius.circular(10),
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
