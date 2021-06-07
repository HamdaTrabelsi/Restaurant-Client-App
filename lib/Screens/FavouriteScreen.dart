import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Favourite.dart';
import 'package:foodz_client/Models/Restaurant.dart';
import 'package:foodz_client/Screens/DetailsScreen.dart';
import 'package:foodz_client/Screens/HomeScreen.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/grid_product.dart';

final _auth = FirebaseAuth.instance;
User _loggedInUser;

class FavouriteScreen extends StatefulWidget {
  static String tag = '/FavouriteScreen';

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with AutomaticKeepAliveClientMixin<FavouriteScreen> {
  List<Favourite> _listFav = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourites"),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("favourites")
                    .where("userId", isEqualTo: _loggedInUser.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(child: CircularProgressIndicator()));
                  }
                  if (snapshot.data.docs.isNotEmpty) {
                    _listFav.clear();
                    snapshot.data.docs.forEach((element) {
                      _listFav.add(Favourite.fromJson(element));
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
                      itemCount: _listFav == null ? 0 : _listFav.length,
                      itemBuilder: (BuildContext context, int index) {
                        Favourite fav = _listFav[index];

                        return FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection("restaurant")
                                .doc(fav.restaurantId)
                                .get(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> restosnapshot) {
                              if (restosnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                        child: CircularProgressIndicator()));
                              }
                              Restaurant resto = Restaurant.fromJson(
                                  restosnapshot.data.data());
                              return futureGridCategory(
                                res: resto,
                              );
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
//             GridView.builder(
//               shrinkWrap: true,
//               primary: false,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: MediaQuery.of(context).size.width /
//                     (MediaQuery.of(context).size.height / 1.25),
//               ),
//               itemCount: restos == null ? 0 : restos.length,
//               itemBuilder: (BuildContext context, int index) {
// //                Food food = Food.fromJson(foods[index]);
//                 Map res = restos[index];
// //                print(foods);
// //                print(foods.length);
//                 return GridProduct(
//                   img: res['img'],
//                   isFav: true,
//                   name: res['name'],
//                   rating: 5.0,
//                   raters: 23,
//                 );
//               },
//             ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
