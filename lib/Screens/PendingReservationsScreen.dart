import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Database/ReservationDB.dart';
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
import 'package:intl/intl.dart';

DateFormat _formatter = DateFormat('yyyy-MM-dd');
final _auth = FirebaseAuth.instance;
User _loggedInUser;
ReservationDB resDB = ReservationDB();

class PendingReservationsScreen extends StatefulWidget {
  static String tag = '/PendingReservationsScreen';

  @override
  _PendingReservationsScreen createState() => _PendingReservationsScreen();
}

class _PendingReservationsScreen extends State<PendingReservationsScreen>
    with AutomaticKeepAliveClientMixin<PendingReservationsScreen> {
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('reservation')
          .where("clientId", isEqualTo: _loggedInUser.uid)
          .where("state", isEqualTo: "Pending")
          .orderBy("sent")
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Container(child: CircularProgressIndicator()));
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
                  //dismissItem(context, index, direction);
                  dismissAction(rev.uid);
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
                            child:
                                Container(child: CircularProgressIndicator()));
                      }
                      if (restSnapshot.data.exists) {
                        Restaurant rest =
                            Restaurant.fromJson(restSnapshot.data);
                        return ActivityWidget(
                          type: rest.title,
                          rating: 5,
                          name: rest.title,
                          people: rev.people,
                          times: [
                            _formatter.format(rev.reservationDay),
                            rev.reservationTime
                          ],
                          imageUrl: rest.image,
                        );
                      } else {
                        return Center(
                            child:
                                Container(child: CircularProgressIndicator()));
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
      },
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

  @override
  bool get wantKeepAlive => true;

  Future<void> dismissAction(String id) async {
    await resDB.editReservationState(state: "Canceled", id: id);
  }
}
