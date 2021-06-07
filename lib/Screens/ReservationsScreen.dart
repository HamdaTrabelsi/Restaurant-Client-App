import 'package:flutter/material.dart';
import 'package:foodz_client/utils/ErrorFlushBar.dart';
import 'package:foodz_client/Screens/PendingReservationsScreen.dart';
import 'package:foodz_client/Screens/AcceptedReservationsScreen.dart';

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

  /*void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    setState(() {
      reservations.removeAt(index);
    });
    ErrorFlush.showErrorFlush(
        context: context, message: 'This reservation has been cancelled');
  }*/

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
