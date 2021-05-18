import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Reservation.dart';
import 'package:foodz_client/Models/Restaurant.dart';
import 'package:foodz_client/Screens/CheckoutScreen.dart';
import 'package:foodz_client/Widgets/ActivityWidget.dart';
import 'package:foodz_client/utils/ErrorFlushBar.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
import 'package:foodz_client/utils/Template/const.dart';
//import 'package:foodz_client/Screens/checkout.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/ReservItem.dart';
import 'package:foodz_client/Widgets/DismissibleWidget.dart';
import 'package:foodz_client/utils/Util.dart';

List reservations = [
  {
    "img": "images/resto/rest1.jpg",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "4",
    "time": "14:15",
    "date": "24 / 08 / 2020"
  },
  {
    "img": "images/resto/rest2.png",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "9",
    "time": "17:15",
    "date": "24 / 15 / 2021"
  },
  {
    "img": "images/resto/rest2.png",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "2",
    "time": "14:15",
    "date": "14 / 09 / 2020"
  },
  {
    "img": "images/resto/rest2.png",
    "comment": "Nulla porttitor accumsan tincidunt. Vestibulum ante "
        "ipsum primis in faucibus orci luctus et ultrices posuere "
        "cubilia Curae",
    "name": "Jane Doe",
    "seats": "4",
    "time": "14:15",
    "date": "24 / 08 / 2020"
  },
];

final _auth = FirebaseAuth.instance;
User _loggedInUser;

class AcceptedReservationsScreen extends StatefulWidget {
  static String tag = '/AcceptedReservationsScreen';

  @override
  _AcceptedReservationsScreen createState() => _AcceptedReservationsScreen();
}

class _AcceptedReservationsScreen extends State<AcceptedReservationsScreen>
    with AutomaticKeepAliveClientMixin<AcceptedReservationsScreen> {
  List<Reservation> _pending = [];

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 10, 10.0, 0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('reservation')
              .where("clientId", isEqualTo: _loggedInUser.uid)
              .where("state", isEqualTo: "Accepted")
              .orderBy("sent")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: Container(child: CircularProgressIndicator()));
            }
            if (snapshot.data.docs.isNotEmpty) {
              _pending.clear();
              snapshot.data.docs.forEach((element) {
                _pending.add(Reservation.fromJson(element));
              });
              return ListView.builder(
                //padding: EdgeInsets.symmetric(vertical: 10),
                //shrinkWrap: true,
                //primary: false,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: _pending == null ? 0 : _pending.length,
                itemBuilder: (BuildContext context, int index) {
                  Reservation rev = _pending[index];
                  return DismissibleWidget(
                    item: rev,
                    ondismissed: (direction) {
                      dismissItem(context, index, direction);
                    },
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('restaurant')
                            .doc(rev.restoId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> restSnapshot) {
                          if (restSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }
                          if (restSnapshot.data.exists) {
                            Restaurant rest =
                                Restaurant.fromJson(restSnapshot.data);
                            return ActivityWidget(
                              type: rest.title,
                              rating: 5,
                              name: rest.title,
                              people: 4,
                              times: ["24/02/2021", rev.reservationTime],
                              imageUrl: rest.image,
                            );
                          } else {
                            return Center(
                                child: Container(
                                    child: CircularProgressIndicator()));
                          }
                        }),
                  );
                },
              );
            } else {
              return Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  width: 280,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                          ),
                          // Image.asset("images/offline/serving-dish.png",
                          //     width: 230, height: 120),
                          SizedBox(
                            height: 20,
                          ),
                          Text("You don't have any reservations !",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Constants.lightAccent,
                                  fontWeight: FontWeight.bold)),
                          Container(height: 10),
                          Text("Make some !",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Constants.lightAccent,
                              )),
                          Container(height: 25),
                        ],
                      )
                    ],
                  ),
                ),
              );
            }
          }),
    );
    // floatingActionButton: FloatingActionButton(
    //   tooltip: "Checkout",
    //   onPressed: () {
    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) {
    //           return CheckoutScreen();
    //           return CheckoutScreen();
    //         },
    //       ),
    //     );
    //   },
    //   child: Icon(
    //     Icons.arrow_forward,
    //   ),
    //   heroTag: Object(),
    // ),
  }

  void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    setState(() {
      reservations.removeAt(index);
    });
    ErrorFlush.showErrorFlush(
        context: context, message: 'This reservation has been cancelled');
  }

  @override
  bool get wantKeepAlive => true;

// void dismissItem(
//     BuildContext context, int index, DismissDirection direction) {
//   setState(() {
//     restos.removeAt(index);
//   });
//   Util.showSnackBar(context, 'This reservation has been cancelled');
// }
}
