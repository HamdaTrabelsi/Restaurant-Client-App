import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/ChoiceChipData.dart';
import 'package:foodz_client/Models/Dish.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/Screens/PlateDetailsScreen.dart';
import 'package:foodz_client/Widgets/Rounded_Food_Card.dart';
import 'package:foodz_client/Widgets/Rouneded_Category_Title.dart';
import 'package:foodz_client/Widgets/food_card.dart';
import 'package:foodz_client/Widgets/grid_product.dart';
import 'package:foodz_client/utils/ChoiceChipData.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/comments.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';

class MenuScreen extends StatefulWidget {
  static String tag = '/DetailsMenuScreen';
  final String restoId;
  const MenuScreen({Key key, this.restoId}) : super(key: key);

  @override
  _MenuScreen createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  List<ChoiceChipData> choiceChips = ChoiceChips.all;
  String _selected;
  List<Dish> listDishes = [];

  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            Text(
              "Menu",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 20.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: choiceChips
                    .map((choiceChip) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text(choiceChip.label),
                            selectedColor: Colors.green,
                            onSelected: (isSelected) {
                              setState(() {
                                choiceChips = choiceChips.map((otherChip) {
                                  final newChip =
                                      otherChip.copy(isSelected: false);
                                  _selected = choiceChip.label;
                                  print(_selected);
                                  return choiceChip == newChip
                                      ? newChip.copy(isSelected: isSelected)
                                      : newChip;
                                }).toList();
                              });
                            },
                            selected: choiceChip.isSelected,
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20.0),
            FutureBuilder(
              future: _selected == "All" || _selected == null
                  ? FirebaseFirestore.instance
                      .collection('dishes')
                      .where("restoID", isEqualTo: widget.restoId)
                      .get()
                  : FirebaseFirestore.instance
                      .collection('dishes')
                      .where("restoID", isEqualTo: widget.restoId)
                      .where("category", isEqualTo: _selected)
                      .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: Container(child: CircularProgressIndicator()));
                }
                //print(snapshot.data.docs[0].id);
                if (snapshot.data.docs.isNotEmpty) {
                  listDishes.clear();
                  snapshot.data.docs.forEach((element) {
                    listDishes.add(Dish.fromJson(element));
                  });

                  //print("the docs   " + snapshot.data.docs.length.toString());
                  //print("the list " + listDishes.length.toString());

                  return GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.25),
                    ),
                    itemCount: listDishes == null ? 0 : listDishes.length,
                    itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                      Dish res = listDishes[index];
//                print(foods);
                      return GridProduct(
                        img: res.image,
                        isFav: true,
                        name: res.name,
                        rating: 5.0,
                        raters: 23,
                        ontap: () {
                          Navigator.pushNamed(context, PlateDetailsScreen.tag,
                              arguments: res.uid);
                        },
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
              },
            ),
//             GridView.builder(
//               shrinkWrap: true,
//               primary: false,
//               physics: NeverScrollableScrollPhysics(),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: MediaQuery.of(context).size.width /
//                     (MediaQuery.of(context).size.height / 1.25),
//               ),
//               itemCount: foods == null ? 0 : foods.length,
//               itemBuilder: (BuildContext context, int index) {
// //                Food food = Food.fromJson(foods[index]);
//                 Map res = foods[index];
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
    //Container(
    //   child: Padding(
    //     padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
    //     child: ListView(
    //       children: <Widget>[
    //         SizedBox(height: 10.0),
    //         Text(
    //           "Menu",
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.w800,
    //           ),
    //           maxLines: 2,
    //         ),
    //         SizedBox(height: 20.0),
    //         SingleChildScrollView(
    //           scrollDirection: Axis.horizontal,
    //           child: Row(
    //             children: <Widget>[
    //               CategoryTitle(title: "All", active: true),
    //               CategoryTitle(title: "Italian"),
    //               CategoryTitle(title: "Asian"),
    //               CategoryTitle(title: "Chinese"),
    //               CategoryTitle(title: "Burgers"),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: 10.0),
    //         // Container(
    //         //     child: GridView.count(
    //         //   shrinkWrap: true,
    //         //   physics: ClampingScrollPhysics(),
    //         //   crossAxisCount: 2,
    //         //   childAspectRatio: ((size.width / 2) / 230),
    //         //   children: this.favoriteFoods.map((product) {
    //         //     return Container(
    //         //       margin: const EdgeInsets.only(top: 10.0),
    //         //       child: FoodCard(
    //         //         img: product['image'],
    //         //         isFav: false,
    //         //         name: product['name'],
    //         //         rating: 5.0,
    //         //         raters: 23,
    //         //       ),
    //         //     );
    //         //   }).toList(),
    //         // ))
    //       ],
    //     ),
    //   ),
    //   /*bottomNavigationBar: Container(
    //     height: 50.0,
    //     child: RaisedButton(
    //       child: Text(
    //         "ADD TO CART",
    //         style: TextStyle(
    //           color: Colors.white,
    //         ),
    //       ),
    //       color: Theme.of(context).accentColor,
    //       onPressed: () {},
    //     ),
    //   ),*/
    // );
  }
}
