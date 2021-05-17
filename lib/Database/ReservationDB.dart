import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Reservation.dart';

class ReservationDB {
  final CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservation');

  User myUser;

  final _auth = FirebaseAuth.instance;

  ReservationDB();

  Future<void> addNewReservation({
    @required String restoId,
    @required String reservationTime,
    @required DateTime reservationDay,
    @required String people,
  }) async {
    //DocumentReference documentReference = userCollection.doc(id);
    myUser = _auth.currentUser;
    String docId = myUser.uid + restoId;
    DocumentReference documentReferencer = reservationCollection.doc();

    Reservation res = new Reservation(
        uid: docId,
        restoId: restoId,
        clientId: myUser.uid,
        sent: Timestamp.now(),
        reservationDay: reservationDay,
        reservationTime: reservationTime,
        people: people,
        state: "Pending");

    var data = res.toJson();
    //
    await documentReferencer.set(data).catchError((e) => throw (e));
  }
}
