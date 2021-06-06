import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Utilisateur.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDB {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  User myUser;

  final _auth = FirebaseAuth.instance;

  UserDB();

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

  Future storeUserImage(
      {@required File upImage,
      @required BuildContext context,
      @required String id}) async {
    // DocumentReference documentReference =
    //     FirebaseFirestore.instance.collection("users").doc(id);

    final ref = FirebaseStorage.instance
        .ref("profile/${basename(upImage.path)}" + DateTime.now().toString());

    //FirebaseStorage storage = FirebaseStorage.instance;

    // Reference ref = storage.ref().child(
    //     "/profile/${basename(upImage.path)}" + DateTime.now().toString());

    //UploadTask uploadTask = ref.putFile(upImage);

    final res = await ref.putFile(upImage);
    //.then((res) {
    return res.ref.getDownloadURL();
    // documentReference
    //     .update({"image": res.ref.getDownloadURL()}).whenComplete(() {
    //   Flushbar(
    //     flushbarPosition: FlushbarPosition.TOP,
    //     title: "Success",
    //     message: "It's done !",
    //     duration: Duration(seconds: 3),
    //   )..show(context);
    // });

    // }).catchError((error) {
    //   Flushbar(
    //     flushbarPosition: FlushbarPosition.TOP,
    //     title: "Error",
    //     message: error.toString(),
    //     duration: Duration(seconds: 3),
    //   )..show(context);
    // });
  }

  Future<void> savePicUrl(
      {@required String id,
      @required String url,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(id);

    documentReference.update({"image": url}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "It's done !",
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    var uid = FirebaseAuth.instance.currentUser.uid;
    DocumentSnapshot fireUser = await userCollection.doc(uid).get();
    return fireUser;
  }

  Future<void> editTextField(
      {@required String id,
      @required String field,
      @required String newValue,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(id);

    documentReference.update({field: newValue}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Saved !",
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  Future<void> editBirthdateField(
      {@required String id,
      @required DateTime newValue,
      @required BuildContext context}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("users").doc(id);

    documentReference.update({"birthDate": newValue}).whenComplete(() {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Success",
        message: "Saved !",
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      )..show(context);
    }).catchError((e) {
      Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        message: e.toString(),
        duration: Duration(seconds: 3),
      )..show(context);
    });
  }

  Future<void> editPassword(
      {@required String oldPass,
      @required String newPass,
      @required String repPass,
      @required BuildContext context}) async {
    myUser = _auth.currentUser;

    if (newPass == repPass) {
      var checkCurrentPass = await validatePassword(oldPass);
      if (checkCurrentPass == false) {
        return Flushbar(
          flushbarPosition: FlushbarPosition.TOP,
          title: "Error",
          backgroundColor: Colors.red,
          message: "Please type your Current Password correctly",
          duration: Duration(seconds: 3),
        )..show(context);
      } else {
        myUser.updatePassword(newPass).whenComplete(() {
          return Flushbar(
            flushbarPosition: FlushbarPosition.TOP,
            backgroundColor: Colors.green,
            title: "Success",
            message: "Your password has been updated !",
            duration: Duration(seconds: 3),
          )..show(context);
          Navigator.pop(context);
        });
      }
    } else {
      // Passwords don't match
      return Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        title: "Error",
        backgroundColor: Colors.red,
        message: "Password and repeated password don't match",
        duration: Duration(seconds: 3),
      )..show(context);
    }
  }

  Future<bool> validatePassword(String password) async {
    myUser = _auth.currentUser;

    var authCredentials =
        EmailAuthProvider.credential(email: myUser.email, password: password);

    try {
      var authResult =
          await myUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }
// Stream<QuerySnapshot> retrieveUsers() {}

  Future<void> changeFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('showWalk', 0);
  }
}
