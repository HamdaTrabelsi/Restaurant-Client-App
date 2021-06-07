import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Review.dart';

class ReviewDB {
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('review');

  User myUser;

  final _auth = FirebaseAuth.instance;

  ReviewDB();

  Future<void> addNewReview(
      {@required String restoId,
      String description = "",
      @required double stars}) async {
    //DocumentReference documentReference = userCollection.doc(id);
    myUser = _auth.currentUser;
    DocumentReference documentReferencer =
        reviewCollection.doc(myUser.uid + restoId);

    Review review = new Review(
        uid: myUser.uid + restoId,
        description: description,
        stars: stars,
        restoId: restoId,
        userId: myUser.uid,
        posted: Timestamp.now());

    var data = review.toJson();
    //
    await documentReferencer
        .set(data)
        .whenComplete(() => print("resto added"))
        .catchError((e) => throw (e));
  }

  Future<void> editReview(
      {@required String restoId,
      @required String description,
      @required double stars}) async {
    //DocumentReference documentReference = userCollection.doc(id);
    myUser = _auth.currentUser;
    DocumentReference documentReferencer =
        reviewCollection.doc(myUser.uid + restoId);

    //
    await documentReferencer
        .update({"description": description, "stars": stars})
        .whenComplete(() => print("resto added"))
        .catchError((e) => throw (e));
  }

  Future<Map<String, double>> reviewInfo({@required String restoId}) async {
    QuerySnapshot reviewDocs =
        await reviewCollection.where("restoId", isEqualTo: restoId).get();

    Map<String, double> revInfo = {};

    List<Review> allRev = [];
    double sumRev = 0;
    double avgRev = 0;

    reviewDocs.docs.forEach((element) {
      allRev.add(Review.fromJson(element));
    });

    allRev.forEach((element) {
      sumRev += element.stars;
    });

    avgRev = sumRev / allRev.length;

    revInfo.addAll({
      "number": allRev.length.toDouble(),
      "average": avgRev.isNaN ? 0 : avgRev
    });
    //print(avgRev);
    return revInfo;
  }
}
