import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Favourite.dart';
import 'package:foodz_client/Models/Reservation.dart';

class FavouriteDB {
  final CollectionReference _favouriteCollection =
      FirebaseFirestore.instance.collection('favourites');

  User _myUser;

  final _auth = FirebaseAuth.instance;

  FavouriteDB();

  Future<void> addToFav(
      {@required String restoId, @required String user}) async {
    //DocumentReference documentReference = userCollection.doc(id);
    //_myUser = _auth.currentUser;
    //String docId = myUser.uid + restoId;
    DocumentReference documentReferencer = _favouriteCollection.doc();

    Favourite fav = new Favourite(
        uid: documentReferencer.id, restaurantId: restoId, userId: user);
    //print("this is the func " + user);
    var data = fav.toJson();
    //
    await documentReferencer.set(data).catchError((e) => throw (e));
  }

  Future<void> removeFavourite({@required String id}) async {
    DocumentReference documentReference = _favouriteCollection.doc(id);

    await documentReference.delete().catchError((e) {
      throw (e);
    });
  }
}
