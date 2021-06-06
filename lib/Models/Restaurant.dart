import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Restaurant {
  String uid;
  //String ownerId;
  String title;
  String phone;
  String description;
  String image;
  String type;
  String website;
  String address;
  GeoPoint location;
  List<String> cuisine = [];
  //List<WorkDay> schedule = [];

  List<dynamic> dList = [];

  Restaurant(
      {this.uid,
      //@required this.ownerId,
      @required this.title,
      @required this.phone,
      @required this.description,
      @required this.image,
      @required this.type,
      this.address,
      this.location,
      this.cuisine,
      //this.schedule,
      this.website});

  Restaurant.fromJson(var json) {
    List<dynamic> tstList = [];
    uid = json['uid'];
    //ownerId = json['ownerId'];
    title = json['title'];
    phone = json['phone'];
    description = json['description'];
    image = json['image'];
    type = json['type'];
    address = json['address'];
    location = json['location'];
    cuisine =
        (json['cuisine'] as List)?.map((item) => item as String)?.toList();
    //schedule = json['schedule'];
    website = json['website'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    //data['ownerId'] = this.ownerId;
    data['title'] = this.title;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['description'] = this.description;
    data['type'] = this.type;
    data['location'] = this.location;
    data['address'] = this.address;
    data['cuisine'] = this.cuisine;
    //data['schedule'] = this.schedule;
    data['website'] = this.website;

    return data;
  }
}
