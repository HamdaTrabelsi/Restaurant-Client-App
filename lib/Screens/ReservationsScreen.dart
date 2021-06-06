import 'package:flutter/material.dart';
import 'package:foodz_client/utils/ErrorFlushBar.dart';
import 'package:foodz_client/Screens/PendingReservationsScreen.dart';
import 'package:foodz_client/Screens/AcceptedReservationsScreen.dart';

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

class ReservationsScreen extends StatefulWidget {
  static String tag = '/ReservationsScreen';

  @override
  _ReservationsScreen createState() => _ReservationsScreen();
}

class _ReservationsScreen extends State<ReservationsScreen>
    with AutomaticKeepAliveClientMixin<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reservations"),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(
              tabs: [
                Tab(text: "Pending"),
                Tab(
                  text: "Accepted",
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          body: TabBarView(
            children: [
              PendingReservationsScreen(),
              AcceptedReservationsScreen(),
            ],
          ),
        ),
      ),
    );
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
