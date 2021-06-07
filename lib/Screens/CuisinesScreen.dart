import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Restaurant.dart';
import 'package:foodz_client/Screens/DetailsScreen.dart';
import 'package:foodz_client/Screens/HomeScreen.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/utils/Template/const.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Widgets/grid_product.dart';

CollectionReference fireRef =
    FirebaseFirestore.instance.collection("restaurant");

class CuisinesScreen extends StatefulWidget {
  static String tag = '/CuisinesScreen';

  @override
  _CuisinesScreen createState() => _CuisinesScreen();
}

class _CuisinesScreen extends State<CuisinesScreen> {
  List<Restaurant> listRest = [];

  @override
  Widget build(BuildContext context) {
    final DishArguments details = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          details.type,
        ),
        elevation: 0.0,
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            Text(
              details.value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Divider(),
            FutureBuilder(
                future: details.type == "cuisine"
                    ? fireRef
                        .where("cuisine", arrayContains: details.value)
                        .get()
                    : fireRef.where("type", isEqualTo: details.value).get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(child: CircularProgressIndicator()));
                  }
                  if (snapshot.data.docs.isNotEmpty) {
                    listRest.clear();
                    snapshot.data.docs.forEach((element) {
                      listRest.add(Restaurant.fromJson(element));
                    });

                    return GridView.builder(
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 1.25),
                      ),
                      itemCount: listRest == null ? 0 : listRest.length,
                      itemBuilder: (BuildContext context, int index) {
                        Restaurant resto = listRest[index];
                        return GridProduct(
                            img: resto.image,
                            isFav: false,
                            name: resto.title,
                            rating: 5.0,
                            raters: 23,
                            ontap: () {
                              Navigator.pushNamed(context, DetailsScreen.tag,
                                  arguments: resto.uid);
                            });
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
                                  height: 100,
                                ),
                                // Image.asset("images/offline/serving-dish.png",
                                //     width: 230, height: 120),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("Empty!",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Constants.lightAccent,
                                        fontWeight: FontWeight.bold)),
                                Container(height: 10),
                                Text(
                                    "You don't have a menu yet, Start by Adding some Dishes !",
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
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
