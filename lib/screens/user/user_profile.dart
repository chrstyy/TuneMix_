import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gracieusgalerij/screens/user/cart_screen.dart';
import 'package:gracieusgalerij/screens/user/fav_screen.dart';
import 'package:gracieusgalerij/screens/user/home_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/auth_service.dart';

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
  final TextEditingController _editedUserNameController =
      TextEditingController();
  bool isDarkMode = false;

  AuthService _authService = AuthService();
  final FirebaseFirestore _database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  File? _imageFile;
  File? _tempImageFile;
  String _tempUsername = '';
  String _profileImageUrl = '';

  bool _showHistory = false;

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

      if (userInfo.exists) {
        print("User info found: ${userInfo.data()}");
        setState(() {
          _userName = userInfo['username'] ?? 'No Username';
          userName = _userName;
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
          userName = newUsername;
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
            onTap: () => choosePhoto(ImageSource.gallery),
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
            onTap: () => _authService.removeCurrentPhoto(),
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
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    color: Colors.black,
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
                              userName,
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
                                    decoration: TextDecoration.underline),
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
                          setState(() {
                            _showHistory = !_showHistory;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF1B26F),
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
                  const SizedBox(height: 10),
                  // Expanded(
                  // child: ListView.builder(
                  //   itemCount: historyList.length,
                  //   itemBuilder: (context, index) {
                  //     return Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //         horizontal: 20,
                  //         vertical: 10,
                  //       ),
                  //       child: Container(
                  //         padding: EdgeInsets.all(10),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.grey),
                  //           borderRadius: BorderRadius.circular(10),
                  //         ),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               width: 80,
                  //               height: 80,
                  //               decoration: BoxDecoration(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 image: DecorationImage(
                  //                   image: AssetImage(historyList[index].productImage),
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //               ),
                  //             ),
                  //             SizedBox(width: 10),
                  //             Expanded(
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     historyList[index].productName,
                  //                     style: TextStyle(
                  //                       fontSize: 18,
                  //                       fontWeight: FontWeight.bold,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 5),
                  //                   Text(
                  //                     'Price: \$${historyList[index].price.toStringAsFixed(2)}',
                  //                     style: TextStyle(fontSize: 16),
                  //                   ),
                  //                   SizedBox(height: 5),
                  //                   Text(
                  //                     'Quantity: ${historyList[index].quantity}',
                  //                     style: TextStyle(fontSize: 16),
                  //                   ),
                  //                   SizedBox(height: 5),
                  //                   Text(
                  //                     'Total: \$${historyList[index].total.toStringAsFixed(2)}',
                  //                     style: TextStyle(fontSize: 16),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),

                  //     );
                  //   },
                  // ),
                  //     )
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
                color: _currentIndex == 0 ? Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: _currentIndex == 1 ? Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                _currentIndex == 2 ? 'images/basket.png' : 'images/basket.png',
                width: 24,
                height: 24,
                color: _currentIndex == 2 ? Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Story',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 3 ? Color(0xFF0500FF) : Colors.black,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle_rounded,
                color: _currentIndex == 4 ? Color(0xFF0500FF) : Colors.black,
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
              return const HomeScreen();
            case 1:
            // return const SearchScreen();
            case 2:
              return const CartScreen(purchasedSongs: [],);
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
