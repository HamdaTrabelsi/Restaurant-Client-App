import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/Details_Menu.dart';
import 'package:foodz_client/Screens/Details_RestInfo.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/comments.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';

import 'Details_Reviews.dart';

class DetailsScreen extends StatefulWidget {
  static String tag = '/DetailsScreen';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    final restoID = ModalRoute.of(context).settings.arguments;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Restaurant Details",
          ),
          titleTextStyle: TextStyle(color: Colors.black54),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.message,
                ),
              ),
              Tab(
                  icon: Icon(
                Icons.local_dining_sharp,
              )),
              Tab(
                  icon: Icon(
                Icons.rate_review,
              )),
            ],
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_backspace,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          elevation: 4.0,
          actions: <Widget>[
            IconButton(
              icon: IconBadge(
                icon: Icons.notifications,
                size: 22.0,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return NotificationScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            RestInfoScreen(
              restoId: restoID,
            ),
            MenuScreen(
              restoId: restoID,
            ),
            ReviewsScreen(restoId: restoID,),
          ],
        ),
      ),
    );
  }
}
