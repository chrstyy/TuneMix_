import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/admin/home_admin.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:gracieusgalerij/screens/user/search_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class UserAdminProfile extends StatefulWidget {
  const UserAdminProfile({super.key});

  @override
  State<UserAdminProfile> createState() => _UserAdminProfileState();
}

class _UserAdminProfileState extends State<UserAdminProfile> {
  int _currentIndex = 1;
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
          canvasColor: themeProvider.themeMode().navbar!,
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
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _currentIndex == 1
                    ? themeProvider.themeMode().navbarIconAct!
                    : themeProvider.themeMode().navbarIcon!,
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
    switch (index) {
      case 0:
        break;
      case 1:
        break;
    }
     Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          switch (index) {
            case 0:
              return const HomeScreenAdmin();
            case 1:
              return const UserAdminProfile();
            default:
              return Container();
          }
        },
      ),
    );
  }
}