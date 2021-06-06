import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Dish {
  String uid;
  String restoID;
  String name;
  String description;
  String cuisine;
  String category;
  String price;
  String image;

  Dish({
    this.uid,
    @required this.restoID,
    @required this.description,
    @required this.image,
    @required this.cuisine,
    @required this.name,
    @required this.price,
    @required this.category,
  });

  Dish.fromJson(var json) {
    uid = json['uid'];
    restoID = json['restoID'];
    description = json['description'];
    image = json['image'];
    cuisine = json['cuisine'];
    name = json['name'];
    price = json['price'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['restoID'] = this.restoID;
    data['description'] = this.description;
    data['image'] = this.image;
    data['cuisine'] = this.cuisine;
    data['name'] = this.name;
    data['price'] = this.price;
    data['category'] = this.category;

    return data;
  }
}
