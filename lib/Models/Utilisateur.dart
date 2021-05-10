import 'package:flutter/material.dart';

class Utilisateur {
  String uid;
  String email;
  String username;
  DateTime birthDate;
  String image;
  String phone;
  String gender;
  String address;
  DateTime created;

  Utilisateur(
      {@required this.uid,
      @required this.username,
      @required this.email,
      @required this.image,
      @required this.created,
      @required this.birthDate,
      @required this.phone,
      @required this.gender,
      @required this.address});

  Utilisateur.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    username = json['username'];
    image = json['image'];
    created = json['created'];
    birthDate = json['birthDate'];
    phone = json['phone'];
    gender = json['gender'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['email'] = this.email;
    data['username'] = this.username;
    data['image'] = this.image;
    data['created'] = this.created;
    data['birthDate'] = this.birthDate;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['address'] = this.address;

    return data;
  }
}
