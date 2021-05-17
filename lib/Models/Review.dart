import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Review {
  String uid;
  String description;
  double stars;
  String restoId;
  String userId;
  Timestamp posted;

  Review({
    this.uid,
    @required this.description,
    @required this.stars,
    @required this.restoId,
    @required this.userId,
    @required this.posted,
  });

  Review.fromJson(var json) {
    uid = json['uid'];
    description = json['description'];
    stars = json['stars'];
    restoId = json['restoId'];
    userId = json['userId'];
    posted = json['posted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['description'] = this.description;
    data['stars'] = this.stars;
    data['restoId'] = this.restoId;
    data['userId'] = this.userId;
    data['posted'] = this.posted;
    return data;
  }
}
