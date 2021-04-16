import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodz_client/Models/FoodModel.dart';
import 'package:foodz_client/Screens/LoginScreen.dart';
import 'package:foodz_client/Screens/Welcome.dart';
import 'package:foodz_client/utils/FoodColors.dart';
import 'package:foodz_client/utils/FoodConstant.dart';
import 'package:foodz_client/utils/FoodDataGenerator.dart';
import 'package:foodz_client/utils/FoodExtension.dart';
import 'package:foodz_client/utils/FoodImages.dart';
import 'package:foodz_client/utils/FoodString.dart';
import 'package:foodz_client/utils/FoodWidget.dart';
import 'package:google_sign_in/google_sign_in.dart';

// import 'FoodAddAddress.dart';
// import 'FoodBookCart.dart';
// import 'FoodDescription.dart';
// import 'FoodFavourite.dart';
// import 'FoodOrder.dart';
// import 'FoodProfile.dart';
// import 'FoodSignIn.dart';
// import 'FoodViewRestaurants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final googleSignIn = GoogleSignIn();
final _auth = FirebaseAuth.instance;

class HomeScreen extends StatefulWidget {
  static String tag = '/FoodDashboard';

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.blueGrey.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Logged In',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          CircleAvatar(
            maxRadius: 25,
            backgroundImage: (NetworkImage(
                /*loggedInUser.photoURL*/ "https://static.scientificamerican.com/sciam/cache/file/7A715AD8-449D-4B5A-ABA2C5D92D9B5A21_source.png")),
          ),
          SizedBox(height: 8),
          // Text(
          //   'Name: ' + loggedInUser.displayName,
          //   style: TextStyle(color: Colors.white),
          // ),
          SizedBox(height: 8),
          Text(
            'Email : ' + loggedInUser.email,
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async {
              if (googleSignIn.currentUser != null) {
                await googleSignIn.disconnect();
              }
              _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.tag);
            },
            child: Text('Logout'),
          )
        ],
      ),
    );
  }
}
