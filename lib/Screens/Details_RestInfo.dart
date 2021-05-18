import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Restaurant.dart';
import 'package:foodz_client/Screens/NoAccountScreen.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/comments.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:foodz_client/Screens/BookingWidget.dart';

final _auth = FirebaseAuth.instance;

class RestInfoScreen extends StatefulWidget {
  static String tag = '/DetailsRestInfoScreen';
  final String restoId;
  const RestInfoScreen({Key key, this.restoId}) : super(key: key);
  @override
  _RestInfoScreen createState() => _RestInfoScreen();
}

class _RestInfoScreen extends State<RestInfoScreen> {
  final panelController = PanelController();
  final double tabBarHeight = 80;
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      minHeight: 80,
      maxHeight: MediaQuery.of(context).size.height - tabBarHeight,
      panelBuilder: (scrollController) => buildSlidingPanel(
          scrollController: scrollController, panelController: panelController),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("restaurant")
            .doc(widget.restoId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            Restaurant resto = Restaurant.fromJson(snapshot.data.data());
            return Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ListView(
                  children: <Widget>[
                    //SizedBox(height: 10.0),
                    Stack(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 3.2,
                          width: MediaQuery.of(context).size.width,
                          child: ClipRRect(
                            //borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              resto.image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: -10.0,
                          top: 3.0,
                          child: RawMaterialButton(
                            onPressed: () {},
                            fillColor: Colors.red,
                            shape: CircleBorder(),
                            elevation: 4.0,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   right: -10.0,
                        //   bottom: 3.0,
                        //   child: RawMaterialButton(
                        //     onPressed: () {},
                        //     fillColor: Colors.white,
                        //     shape: CircleBorder(),
                        //     elevation: 4.0,
                        //     child: Padding(
                        //       padding: EdgeInsets.all(5),
                        //       child: Icon(
                        //         isFav ? Icons.favorite : Icons.favorite_border,
                        //         color: Colors.red,
                        //         size: 17,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    //SizedBox(height: 10.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        elevation: 2,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        resto.title,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
                                        maxLines: 2,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 5.0, top: 2.0),
                                        child: Row(
                                          children: <Widget>[
                                            StarRating(
                                              starCount: 5,
                                              color: Constants.ratingBG,
                                              allowHalfRating: true,
                                              rating: 5.0,
                                              size: 10.0,
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "5.0 (23 Reviews)",
                                              style: TextStyle(
                                                fontSize: 11.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      RawMaterialButton(
                                        onPressed: () {},
                                        fillColor: Colors.white,
                                        shape: CircleBorder(),
                                        elevation: 4.0,
                                        child: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            isFav
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: Colors.red,
                                            size: 17,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              // Padding(
                              //   padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
                              //   child: Row(
                              //     children: <Widget>[
                              //       Text(
                              //         "20 Pieces",
                              //         style: TextStyle(
                              //           fontSize: 11.0,
                              //           fontWeight: FontWeight.w300,
                              //         ),
                              //       ),
                              //       SizedBox(width: 10.0),
                              //       Text(
                              //         r"$90",
                              //         style: TextStyle(
                              //           fontSize: 14.0,
                              //           fontWeight: FontWeight.w900,
                              //           color: Theme.of(context).accentColor,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              SizedBox(height: 20.0),
                              Text(
                                "Restaurant Description",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                resto.description,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              SizedBox(height: 20.0),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.location_pin,
                                  color: /*Colors.green*/ Theme.of(context)
                                      .accentColor,
                                ),
                                title: Text(
                                  "Address",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      resto.address,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                              ExpansionTile(
                                leading: Icon(
                                  Icons.phone,
                                  color: /*Colors.green*/ Theme.of(context)
                                      .accentColor,
                                ),
                                title: Text(
                                  "Phone Number",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w800),
                                ),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      resto.phone,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              ExpansionTile(
                                  leading: Icon(
                                    Icons.local_restaurant,
                                    color: /*Colors.green*/ Theme.of(context)
                                        .accentColor,
                                  ),
                                  title: Text(
                                    "Cuisine",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  children: resto.cuisine.map((e) {
                                    return ListTile(
                                      title: Text(e),
                                    );
                                  }).toList()),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Latest Reviews",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 2,
                              ),
                              SizedBox(height: 20.0),
                              ListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    comments == null ? 0 : comments.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Map comment = comments[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 25.0,
                                      backgroundImage: AssetImage(
                                        "${comment['img']}",
                                      ),
                                    ),
                                    title: Text("${comment['name']}"),
                                    subtitle: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            StarRating(
                                              starCount: 5,
                                              color: Constants.ratingBG,
                                              allowHalfRating: true,
                                              rating: 5.0,
                                              size: 12.0,
                                            ),
                                            SizedBox(width: 6.0),
                                            Text(
                                              "February 14, 2020",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 7.0),
                                        Text(
                                          "${comment["comment"]}",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 70.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /*bottomNavigationBar: Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "ADD TO CART",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {},
            ),
          ),*/
            );
          }
        },
      ),
    );
  }

  Widget buildSlidingPanel({
    @required PanelController panelController,
    @required ScrollController scrollController,
  }) =>
      DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: buildTabBar(
            onClicked: panelController.open,
          ),
          body: TabBarView(
            children: [
              _auth.currentUser == null
                  ? NoAccountScreen()
                  : BookingWidget(
                      scrollController: scrollController,
                      restId: widget.restoId,
                    ),
            ],
          ),
        ),
      );

  Widget buildTabBar({@required VoidCallback onClicked}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(tabBarHeight),
      child: GestureDetector(
        onTap: onClicked,
        child: AppBar(
          title: buildDragIcon(), //Icon(Icons.drag_handle),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'Book a Table',
                  //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
      ),
    );
  }

  Widget buildDragIcon() => Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8)),
        width: 52,
        height: 8,
      );
}
