import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/DishesScreen.dart';
//import 'package:restaurant_ui_kit/screens/dishes.dart';
import 'package:foodz_client/Widgets/grid_product.dart';
import 'package:foodz_client/Widgets/grid_category.dart';
import 'package:foodz_client/Widgets/Category_Item.dart';
import 'package:foodz_client/Widgets/home_category.dart';
import 'package:foodz_client/Widgets/offers_card.dart';
import 'package:foodz_client/Widgets/slider_item.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/utils/Template/categories.dart';
import 'package:foodz_client/utils/Template/cuisines.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final screen_size_width = MediaQuery.of(context).size.width;
    final screen_size_height = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      backgroundColor: /*Colors.grey[100]*/ Theme.of(context).primaryColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Text(
              "Recent Offers",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                height: screen_size_height * .2,
                width: screen_size_width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    ImageCard(
                      cardImg: "images/template/food1.jpeg",
                      btnText: "GET UP TO 50% OFF",
                      onpress: () {},
                    ),
                    SizedBox(width: 10),
                    ImageCard(
                      cardImg: "images/template/food2.jpeg",
                      btnText: "GET UP TO 50% OFF",
                      onpress: () {},
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Featured Restaurants",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DishesScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10.0),

            //Slider Here

            CarouselSlider(
              items: map<Widget>(
                restos,
                (index, i) {
                  Map res = restos[index];
                  return SliderItem(
                    img: res['img'],
                    isFav: false,
                    name: res['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),
              /*map<Widget>(
                foods,
                (index, i) {
                  Map food = foods[index];
                  return SliderItem(
                    img: food['img'],
                    isFav: false,
                    name: food['name'],
                    rating: 5.0,
                    raters: 23,
                  );
                },
              ).toList(),*/
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 2.4,

                autoPlay: true,
//                enlargeCenterPage: true,
                viewportFraction: 1.0,
//              aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
            SizedBox(height: 20.0),

            Text(
              "Type",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            Container(
              height: 65.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categories == null ? 0 : categories.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categories[index];
                  return HomeCategory(
                    icon: cat['icon'],
                    title: cat['name'],
                    items: cat['items'].toString(),
                    isHome: true,
                  );
                },
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              "Cuisines",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10.0),

            //SizedBox(height: 20.0),

            Container(
              height: MediaQuery.of(context).size.height / 6,
              child: ListView.builder(
                primary: false,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: categs == null ? 0 : categs.length,
                itemBuilder: (BuildContext context, int index) {
                  Map cat = categs[index];

                  return CategoryItem(
                    cat: cat,
                  );
                },
              ),
            ),

            SizedBox(height: 20.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Worth Checking",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                FlatButton(
                  child: Text(
                    "View More",
                    style: TextStyle(
//                      fontSize: 22,
//                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: 10.0),

            GridView.builder(
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                //childAspectRatio: MediaQuery.of(context).size.width /
                //    (MediaQuery.of(context).size.height / 1.25),
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 1.4),
              ),
              itemCount: restos == null ? 0 : restos.length,
              itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
                Map cui = restos[index];
//                print(foods);
//                print(foods.length);
                /*return GridProduct(
                  img: food['img'],
                  isFav: false,
                  name: food['name'],
                  rating: 5.0,
                  raters: 23,
                );*/
                return GridCategory(
                  img: cui['img'],
                  isFav: false,
                  name: cui['name'],
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
  }

  @override
  bool get wantKeepAlive => true;
}
