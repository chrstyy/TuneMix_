import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _currentIndex = 4;
  String _userName = 'Initial Username';
  bool isSignedIn = false;
  final TextEditingController _editedUserNameController =
      TextEditingController();
  bool _showAboutUs = false;
  bool _showContact = false;

  AuthService _authService = AuthService();
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _imageFile;
  File? _tempImageFile;
  String _tempUsername = '';
  String _profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _getUserInfo();
  }

  void _showAboutUsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Us'),
          content: Text(
            'TuneMix adalah aplikasi e-commerce aransemen musik yang memungkinkan pengguna untuk menjelajahi dan membeli aransemen musik dari berbagai genre. Aplikasi ini dirancang untuk memberikan pengalaman pengguna yang intuitif dan menyenangkan, baik untuk pengguna biasa maupun admin.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Emergency Contact'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('rayvin_putra_tapasya@gmail.com'),
              Text('christy_permata_sari@gmail.com'),
              Text('jocelyn_harpasari@gmail.com'),
              Text('callista_putri_khadijah@gmail.com'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
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

      if (userInfo.exists) {
        print("User info found: ${userInfo.data()}");
        setState(() {
          _userName = userInfo['username'] ?? 'No Username';
          _tempUsername = _userName;
          _tempUsername = _userName;
          _editedUserNameController.text = _userName;
        });
      }
    }
  }

  Future<void> _updateUsername() async {
    String newUsername = _editedUserNameController.text.trim();
    print('Attempting to update username to: $newUsername');
    if (newUsername.isEmpty) {
      print('Username cannot be empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username cannot be empty')),
      );
      return;
    }

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _database.collection('users').doc(user.uid).update({
          'username': newUsername,
        });

        setState(() {
          _userName = newUsername;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update username')),
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
            String email = userData['username'];
            _userName = email.split('@')[0];
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
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
            onTap: () => choosePhoto(ImageSource.gallery),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Choose from Library'),
                  Divider(
                    color: themeProvider.themeMode().switchColor!,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => choosePhoto(ImageSource.camera),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Take Photo'),
                  Divider(
                    color: themeProvider.themeMode().switchColor!,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _authService.removeCurrentPhoto(),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Remove Current Photo'),
                  Divider(
                    color: themeProvider.themeMode().switchColor!,
                  ),
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
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    color: themeProvider.themeMode().switchColor!,
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: EdgeInsets.all(16),
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
          TextFormField(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    color: themeProvider.themeMode().switchColor!,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _updateUsername();
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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: themeProvider.themeMode().gradientColors!,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
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
                                child: _tempImageFile == null
                                    ? Image.network(
                                        'https://images.unsplash.com/photo-1519283053578-3efb9d2e71bd?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTYyMDF8MHwxfHNlYXJjaHw4fHxjYXJ0b29uJTIwcHJvZmlsZXxlbnwwfHx8fDE3MDI5MTExMzl8MA&ixlib=rb-4.0.3&q=80&w=1080',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(_tempImageFile!,
                                        fit: BoxFit.cover),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                left: 83,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        themeProvider.themeMode().switchColor!,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      _showEditOptions(context);
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
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
                              _userName,
                              style: Theme.of(context).textTheme.headline1!,
                            ),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () {
                                _showUsernameUpdate(context);
                              },
                              child: Text(
                                'Edit Username',
                                style: Theme.of(context).textTheme.headline2!,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 43,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFAF8F6F),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.nights_stay_outlined),
                              onPressed: () {
                                themeProvider.toggleThemeData();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _signOut();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9D3939),
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
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showAboutUs = !_showAboutUs;
                                _showContact = false;
                              });
                            },
                            icon: Icon(Icons.help_outline),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _showContact = !_showContact;
                                _showAboutUs = false;
                              });
                            },
                            icon: Icon(Icons.contact_phone_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 2,
                    color: themeProvider.themeMode().switchColor!,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 100,
                    child: Visibility(
                      visible: _showAboutUs || _showContact,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        color: themeProvider.themeMode().switchBgColor!,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (_showAboutUs)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'About Us :',
                                    style: TextStyle(
                                      fontFamily: 'Bayon',
                                      fontSize: 20,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'TuneMix adalah aplikasi e-commerce aransemen musik yang memungkinkan pengguna untuk menjelajahi dan membeli aransemen musik dari berbagai genre. Aplikasi ini dirancang untuk memberikan pengalaman pengguna yang intuitif dan menyenangkan, baik untuk pengguna biasa maupun admin.',
                                    style: TextStyle(
                                      fontFamily: 'Basic',
                                      fontSize: 18,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            if (_showContact)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Contact Us :',
                                    style: TextStyle(
                                      fontFamily: 'Bayon',
                                      fontSize: 20,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'rayvin_putra_tapasya@gmail.com',
                                    style: TextStyle(
                                      fontFamily: 'Basic',
                                      fontSize: 18,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  Text(
                                    'christy_permata_sari@gmail.com',
                                    style: TextStyle(
                                      fontFamily: 'Basic',
                                      fontSize: 18,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  Text(
                                    'jocelyn_ratna_harpasari@gmail.com',
                                    style: TextStyle(
                                      fontFamily: 'Basic',
                                      fontSize: 18,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                  Text(
                                    'callista_putri_khadijah@gmail.com',
                                    style: TextStyle(
                                      fontFamily: 'Basic',
                                      fontSize: 18,
                                      color:
                                          themeProvider.themeMode().thumbColor!,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: const Color(0xFFE2DFD0),
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
                color:
                    _currentIndex == 0 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color:
                    _currentIndex == 1 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2 ? 'images/basket.png' : 'images/basket.png',
                width: 24,
                height: 24,
                color:
                    _currentIndex == 2 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color:
                    _currentIndex == 3 ? const Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color:
                    _currentIndex == 4 ? const Color(0xFF0500FF) : Colors.black,
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
        routeBuilder = '/cart';
        break;
      case 3:
        routeBuilder = '/favorite';
        break;
      case 4:
        routeBuilder = '/user';
        break;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (index) {
            case 0:
              return const HomeScreen();
            case 1:
            // return const SearchScreen();
            case 2:
              return const CartScreen(
                purchasedSongs: [],
              );
            case 3:
              return const FavoriteScreen();
            case 4:
              return const UserProfile();
            default:
              return Container();
          }
        },
      ),
    );
  }
}
