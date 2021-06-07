import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favourite {
  String uid;
  String userId;
  String restaurantId;

  Favourite({this.uid, @required this.restaurantId, @required this.userId});

  Favourite.fromJson(var json) {
    uid = json['uid'];
    userId = json['userId'];
    restaurantId = json['restaurantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['userId'] = this.userId;
    data['restaurantId'] = this.restaurantId;
    return data;
  }
}
