import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Reservation {
  String uid;
  String restoId;
  String clientId;
  Timestamp sent;
  DateTime reservationDay;
  String reservationTime;
  String people;
  String state;

  Reservation({
    this.uid,
    @required this.restoId,
    @required this.clientId,
    @required this.people,
    @required this.reservationDay,
    @required this.reservationTime,
    @required this.sent,
    @required this.state,
  });

  Reservation.fromJson(var json) {
    uid = json['uid'];
    restoId = json['restoId'];
    clientId = json['clientId'];
    people = json['people'];
    Timestamp resDay = json['reservationDay'];
    reservationDay = resDay.toDate();
    reservationTime = json['reservationTime'];
    sent = json['sent'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['uid'] = this.uid;
    data['restoId'] = this.restoId;
    data['clientId'] = this.clientId;
    data['people'] = this.people;
    data['reservationDay'] = this.reservationDay;
    data['reservationTime'] = this.reservationTime;
    data['sent'] = this.sent;
    data['state'] = this.state;
    return data;
  }
}
