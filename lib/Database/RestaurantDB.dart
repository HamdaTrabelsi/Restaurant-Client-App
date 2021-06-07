import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Reservation.dart';
import 'package:foodz_client/Models/Restaurant.dart';

class RestaurantDB {
  final CollectionReference restaurantCollection =
      FirebaseFirestore.instance.collection('restaurant');

  User myUser;

  final _auth = FirebaseAuth.instance;

  RestaurantDB();

  Future<List<Restaurant>> getFeatured() async {
    List<Restaurant> _featRest = [];
    QuerySnapshot _queryReferencer =
        await restaurantCollection.orderBy("title").limit(5).get();

    _queryReferencer.docs.forEach((element) {
      _featRest.add(Restaurant.fromJson(element));
    });
    //
    return _featRest;
  }
}
