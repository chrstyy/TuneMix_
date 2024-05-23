import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gracieusgalerij/screens/home_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentIndex = 4;
  String userName = '';
  String _userName = 'Initial Username';
  bool isSignedIn = false;
  final TextEditingController _editedUserNameController = TextEditingController();
  bool isDarkMode = false;

  AuthService _authService = AuthService();
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _imageFile;
  File? _tempImageFile;
  String _tempUsername = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
     _getUserInfo();
  }

  void _signOut() async {
      try {
        await FirebaseAuth.instance.signOut();
        setState(() {
          isSignedIn = false;
        });
      } catch (e) {
        print('Error signing out: $e');
      }

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, '/landing');
      });

      _loadUserData();
    }

  Future<void> choosePhoto(ImageSource source) async {
    await _authService.editPhoto(source);
    setState(() {
        _tempImageFile = _authService.imageFile;
    });
    Navigator.pop(context);
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userInfo =
          await _database.collection('users').doc(user.uid).get();

      setState(() {
        _userName = userInfo['username'];
        _tempUsername = _userName; 
        _editedUserNameController.text = _userName; 
      });
    }
  }

  Future<void> _updateUsername() async {
    String newUsername = _editedUserNameController.text.trim();
    try {
      await AuthService().editUsername(newUsername);

      // Update username di dalam Firestore
      User? user = _auth.currentUser;
      if (user != null) {
        await _database.collection('users').doc(user.uid).update({
          'username': newUsername,
        });

        setState(() {
          _userName = newUsername;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update username: $e')),
      );
    }
  }


  Future<void> _loadUserData() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();

        if (userData.exists) {
          setState(() {
            String email = userData['userName'];
            userName = email.split('@')[0];
            isSignedIn = true;
            _tempImageFile = userData['profileImageUrl'];
          });
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _savePhoto() async {
    try {
      if (_tempImageFile != null) {
        await _authService.updateProfilePhoto(_tempImageFile!);
      }
    } catch (e) {
      print('Error saving photo: $e');
    }
  }

  void _showEditOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SingleChildScrollView(
            child: _buildEditOptions(context),
          ),
        );
      },
    );
  }

  void _showUsernameUpdate(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          content: SingleChildScrollView(
            child: _builUsernameUpdate(context),
          ),
        );
      },
    );
  }

  Widget _buildEditOptions(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'CHANGE PROFILE PHOTO',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Concert One',
            ),
          ),
        ),
        GestureDetector(
          onTap: ()=> choosePhoto(ImageSource.gallery),
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Choose from Library'),
                Divider(color: Colors.black),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () => choosePhoto(ImageSource.camera),
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Take Photo'),
                Divider(color: Colors.black),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: ()  => _authService.removeCurrentPhoto(),
          child: const Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Remove Current Photo'),
                Divider(color: Colors.black),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Itim',
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

 Widget _builUsernameUpdate(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    color: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'CHANGE USERNAME',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Concert One',
            ),
          ),
        ),
Expanded(
              flex: 2,
              child: TextFormField(
                controller: _editedUserNameController,
                onChanged: (value) {
                  setState(() {
                    _tempUsername = value;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'Enter new username',
                  hintStyle: TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 13,
                    color: Colors.black,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Itim',
                  color: Colors.black,
                ),
              ),
            ),
            GestureDetector(
              onTap: ()  {
                 setState(() {
                    _userName = _tempUsername; 
                  });
                  Navigator.pop(context);
              },
              child: const Text(
                'Save',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = isDarkMode ? ThemeData.dark() : ThemeData.light();

    return Scaffold(
      body: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Image.asset(
                'images/logo.png',
                width: 300,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF8F4E1),
                  Color(0xFFAF8F6F),
                ],
                stops: [0.33, 1],
                begin: AlignmentDirectional(0, -1),
                end: AlignmentDirectional(0, 1),
              ),
            ),
            alignment: const AlignmentDirectional(0, -1),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 80, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child:  _tempImageFile == null
                                      ? Image.network(
                                          'https://images.unsplash.com/photo-1519283053578-3efb9d2e71bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxjYXJ0b29uJTIwcHJvZmlsZXxlbnwwfHx8fDE3MDI5MTExMzl8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                          fit: BoxFit.cover,
                                        )
                                      : Image.file(_tempImageFile!, fit: BoxFit.cover),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              left: 83,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: IconButton(
                                                  onPressed: () {
                                                    _showEditOptions(context);
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             '$_userName',
                              style: const TextStyle(
                                fontFamily: 'Bayon',
                                fontWeight: FontWeight.bold,
                                fontSize: 35,
                              ),
                            ),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () {
                                _showUsernameUpdate(context);
                              },
                              child: const Text(
                                'Edit Username',
                                style: TextStyle(
                                  fontFamily: 'Belgrano', 
                                  fontSize: 11,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                         
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF1B26F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fixedSize: const Size(140, 48),
                        ),
                        child: const Text(
                          'HISTORY',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'BlackOpsOne',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          // Tambahkan logika untuk dark mode di sini
                          setState(() {
                            // Tambahkan logika untuk mengubah warna lingkaran
                          });
                        },
                        child: Container(
                          width: 44,
                          height: 43,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFAF8F6F),
                          ),
                          child: Image.asset(
                            'images/darkmode.png',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                      const SizedBox(width: 65),
                      ElevatedButton(
                      onPressed: () {
                        _signOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9D3939),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(91, 28),
                      ),
                      child: const Text(
                        'LOGOUT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          fontSize: 15,
                          color: Colors.white
                        ),
                      ),
                    ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color.fromARGB(255, 214, 240, 238),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _navigateToPage(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0
                    ? Colors.deepPurple
                    : const Color.fromARGB(255, 48, 162, 159),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _currentIndex == 1
                    ? Colors.deepPurple
                    : const Color.fromARGB(255, 48, 162, 159),
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2
                    ? 'images/basket.png'
                    : 'images/basket.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2
                    ? Colors.deepPurple
                    : const Color.fromARGB(255, 48, 162, 159),
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 3
                    ? Colors.deepPurple
                    : const Color.fromARGB(255, 48, 162, 159),
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _currentIndex == 4
                    ? Colors.deepPurple
                    : const Color.fromARGB(255, 48, 162, 159),
              ),
              label: 'Account',
            ),
          ],
          showUnselectedLabels: false,
          showSelectedLabels: false,
        ),
      ),
    );
  }

  void _navigateToPage(int index) {
    var routeBuilder;
    switch (index) {
      case 0:
        routeBuilder = '/home';
        break;
      case 1:
        routeBuilder = '/search';
        break;
      case 2:
        routeBuilder = '/basket';
        break;
      case 3:
        routeBuilder = '/fav';
        break;
      case 4:
        routeBuilder = '/account';
        break;
    }

    // if (index == 2) {
    //   Navigator.push(
    //       context,
    //       PageRouteBuilder(
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             const StoryListScreen(),
    //         transitionsBuilder:
    //             (context, animation, secondaryAnimation, child) {
    //           const begin = 0.0;
    //           const end = 1.0;
    //           var tween = Tween(begin: begin, end: end);

    //           var fadeOutAnimation = animation.drive(tween);

    //           return FadeTransition(
    //             opacity: fadeOutAnimation,
    //             child: child,
    //           );
    //         },
    //         transitionDuration: const Duration(milliseconds: 500),
    //       ));
    // }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (index) {
            case 0:
             // return const HomeScreen();
            case 1:
             // return const SearchScreen();
            case 2:
             //return const StoryListScreen();
            case 3:
              return const HomeScreen(
                // favoriteSongs: [],
                //  favoritePodcasts: [],
              );
            case 4:
              return  UserProfile();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
