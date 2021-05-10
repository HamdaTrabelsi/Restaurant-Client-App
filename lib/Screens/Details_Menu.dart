import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/Screens/PlateDetailsScreen.dart';
import 'package:foodz_client/Widgets/Rounded_Food_Card.dart';
import 'package:foodz_client/Widgets/Rouneded_Category_Title.dart';
import 'package:foodz_client/Widgets/food_card.dart';
import 'package:foodz_client/Widgets/grid_product.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/comments.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';

class MenuScreen extends StatefulWidget {
  static String tag = '/DetailsMenuScreen';

  @override
  _MenuScreen createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  final List<Map<String, String>> favoriteFoods = [
    {
      'name': 'Tandoori Chicken',
      'price': '96.00',
      'rate': '4.9',
      'clients': '200',
      'image': 'images/template/food1.jpeg'
    },
    {
      'name': 'Salmon',
      'price': '40.50',
      'rate': '4.5',
      'clients': '168',
      'image': 'images/template/food2.jpeg'
    },
    {
      'name': 'Rice and meat',
      'price': '130.00',
      'rate': '4.8',
      'clients': '150',
      'image': 'images/template/food3.jpeg'
    }
  ];

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
                children: <Widget>[
                  CategoryTitle(title: "All", active: true),
                  CategoryTitle(title: "Dessert"),
                  CategoryTitle(title: "Main Course"),
                  CategoryTitle(title: "Fast Food"),
                  CategoryTitle(title: "Appetizer"),
                  CategoryTitle(title: "Drinks"),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.25),
              ),
              itemCount: foods == null ? 0 : foods.length,
              itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                Map res = foods[index];
//                print(foods);
//                print(foods.length);
                return GridProduct(
                  img: res['img'],
                  isFav: true,
                  name: res['name'],
                  rating: 5.0,
                  raters: 23,
                );
              },
            ),
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
