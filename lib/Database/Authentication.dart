import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Utilisateur.dart';
import 'package:foodz_client/Screens/MainScreen.dart';
import 'package:foodz_client/Screens/Welcome.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final _auth = FirebaseAuth.instance;

  User myUser;

  Authentication();

  storeUserData({
    @required String id,
    @required String name,
    @required String mail,
  }) async {
    DocumentReference documentReference = userCollection.doc(id);

    Utilisateur user = Utilisateur(
        uid: id,
        username: name,
        email: mail,
        image: "",
        created: Timestamp.now(),
        birthDate: null,
        phone: "",
        gender: "",
        address: "");

    var data = user.toJson();

    await documentReference.set(data).whenComplete(() {
      print("User data added");
    }).catchError((e) => print(e));
  }

  Future<DocumentSnapshot> getUserData() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot fireUser = await userCollection.doc(uid).get();
    return fireUser;
  }

  Stream<QuerySnapshot> retrieveUsers() {}

  Future<void> signOut({@required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();
    myUser = _auth.currentUser;

    try {
      if (myUser != null) {
        if (myUser.providerData[0].providerId == "google.com") {
          await googleSignIn.disconnect();
          await googleSignIn.signOut();
        }
      }
      await FirebaseAuth.instance.signOut();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pushNamed(context, WelcomeScreen.tag);
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> signInWithGoogle({@required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();

    final user = await googleSignIn.signIn();
    if (user == null) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        //title: "Error",
        message: "Operation Cancelled",
        duration: Duration(seconds: 3),
      )..show(context);
    } else {
      final googleAuth = await user.authentication;

      try {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        UserCredential cred =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (cred.additionalUserInfo.isNewUser) {
          await storeUserData(
              id: cred.user.uid,
              name: cred.user.displayName,
              mail: cred.user.email);
        }
        // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //   return MainScreen();
        // }));
        Navigator.pop(context);
        Navigator.pushNamed(context, MainScreen.tag);
      } catch (e) {
        Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "Error",
          message: e.toString(),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
  }

  Future<void> classicSignUp(
      {@required BuildContext context,
      @required String email,
      @required String password,
      @required String username}) async {
    final _auth = FirebaseAuth.instance;

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      newUser.user.updateProfile(displayName: username);
      if (newUser != null) {
        await storeUserData(
            id: _auth.currentUser.uid,
            name: username,
            mail: _auth.currentUser.email);

        Navigator.pop(context);
        Navigator.pushNamed(context, MainScreen.tag);
      }
    } catch (e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<void> classicSignIn(
      {@required BuildContext context,
      @required String email,
      @required String password}) async {
    final _auth = FirebaseAuth.instance;

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        //Navigator.pushNamed(context, MainScreen.tag);
        //Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushNamed(context, MainScreen.tag);
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
      //     content: 'Error: ' + e.toString(), color: Colors.redAccent));
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }
}
