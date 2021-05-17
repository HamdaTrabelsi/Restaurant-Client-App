import 'package:flutter/material.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/grid_product.dart';

class FavouriteScreen extends StatefulWidget {
  static String tag = '/FavouriteScreen';

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with AutomaticKeepAliveClientMixin<FavouriteScreen> {
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
