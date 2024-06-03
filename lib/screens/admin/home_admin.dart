import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:gracieusgalerij/models/song.dart';
import 'package:gracieusgalerij/screens/admin/edit_genre.dart';
import 'package:gracieusgalerij/screens/admin/edit_product_detail_admin.dart';
import 'package:gracieusgalerij/screens/admin/widget/widget_genre.dart';
import 'package:gracieusgalerij/screens/theme/theme_app.dart';
import 'package:gracieusgalerij/screens/user/song_list.dart';
import 'package:gracieusgalerij/services/song_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'widget/widget_offer.dart';
import 'widget/widget_recommend.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  State<HomeScreenAdmin> createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
  final SongService _songService = SongService();

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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'images/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                //   child: Row(
                //     mainAxisSize: MainAxisSize.max,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Expanded(
                //         child: Container(
                //           width: 110,
                //           height: 40,
                //           decoration: BoxDecoration(
                //             gradient: const LinearGradient(
                //               colors: [Color(0xFF747474), Color(0xFFC1C1C1)],
                //               stops: [0, 1],
                //               begin: AlignmentDirectional(0, -1),
                //               end: AlignmentDirectional(0, 1),
                //             ),
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           child: Padding(
                //             padding: const EdgeInsets.all(10),
                //             child: Row(
                //               mainAxisSize: MainAxisSize.max,
                //               children: [
                //                 const Icon(
                //                   Icons.search,
                //                   color: Colors.white,
                //                   size: 24,
                //                 ),
                //                 Expanded(
                //                   child: Padding(
                //                     padding:
                //                         const EdgeInsetsDirectional.fromSTEB(
                //                             8, 0, 8, 0),
                //                     child: TextFormField(
                //                       autofocus: true,
                //                       obscureText: false,
                //                       cursorColor: Colors.white,
                //                       decoration: InputDecoration(
                //                         border: OutlineInputBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(15.0),
                //                           borderSide: const BorderSide(
                //                             color: Colors.transparent,
                //                           ),
                //                         ),
                //                         focusedBorder: OutlineInputBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(15.0),
                //                           borderSide: const BorderSide(
                //                             color: Colors.white,
                //                             width: 2,
                //                           ),
                //                         ),
                //                         filled: true,
                //                         fillColor: Colors.transparent,
                //                       ),
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ),
                //       Row(
                //         children: [
                //           GestureDetector(
                //             onTap: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) =>
                //                         const EditProductDetail()),
                //               );
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 20),
                //               child: Icon(
                //                 Icons.add_circle_sharp,
                //                 color: themeProvider.themeMode().switchColor!,
                //                 size: 24,
                //               ),
                //             ),
                //           ),
                //           GestureDetector(
                //            onTap: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(
                //                     builder: (context) => SongList()),
                //               );
                //             },
                //             child: Padding(
                //               padding: const EdgeInsets.only(left: 10),
                //               child: Icon(
                //                 Icons.view_list,
                //                 color: themeProvider.themeMode().switchColor!,
                //                 size: 24,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
                Row(
  mainAxisSize: MainAxisSize.max,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        'Special Offer',
        style: TextStyle(
          fontFamily: 'Bayon',
          fontSize: 20,
        ),
      ),
    ),
    Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const EditProductDetail()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Icon(
              Icons.add_circle_sharp,
              color: themeProvider.themeMode().switchColor!,
              size: 24,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SongList()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Icon(
              Icons.view_list,
              color: themeProvider.themeMode().switchColor!,
              size: 24,
            ),
          ),
        ),
      ],
    ),
  ],
),

                SizedBox(child: WidgetOffer()),
                const Padding(
                  padding: EdgeInsets.only(top: 20, right: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Genre',
                        style: TextStyle(
                          fontFamily: 'Bayon',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode().switchBgColor!,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 0, 5),
                    child: WidgetGenre(),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'Recommendation',
                    style: TextStyle(
                      fontFamily: 'Bayon',
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(child: WidgetRecommendation()),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
