import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/DetailsScreen.dart';
import 'package:foodz_client/Screens/PlateDetailsScreen.dart';
//import 'package:restaurant_ui_kit/screens/details.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';

class GridProduct extends StatelessWidget {
  final String name;
  final String img;
  final bool isFav;
  final double rating;
  final int raters;
  final Function ontap;

  GridProduct(
      {Key key,
      @required this.name,
      @required this.img,
      @required this.isFav,
      @required this.rating,
      @required this.raters,
      @required this.ontap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: ListView(
          shrinkWrap: true,
          primary: false,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 3.6,
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "$img",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 2.0, top: 8.0),
              child: Text(
                "$name",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w900,
                ),
                maxLines: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
              child: Row(
                children: <Widget>[
                  StarRating(
                    starCount: 5,
                    color: Constants.ratingBG,
                    allowHalfRating: true,
                    rating: rating,
                    size: 10.0,
                  ),
                  Text(
                    " $rating ($raters Reviews)",
                    style: TextStyle(
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: ontap);
  }
}
