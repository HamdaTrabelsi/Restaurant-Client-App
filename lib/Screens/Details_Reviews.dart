import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
//import 'package:restaurant_ui_kit/screens/notifications.dart';
import 'package:foodz_client/utils/Template/comments.dart';
import 'package:foodz_client/utils/Template/common.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/badge.dart';
import 'package:foodz_client/Screens/WriteReviewScreen.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';
import 'package:foodz_client/utils/Template/tap_opacity.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ReviewsScreen extends StatefulWidget {
  static String tag = '/DetailsScreen';

  @override
  _ReviewsScreen createState() => _ReviewsScreen();
}

class _ReviewsScreen extends State<ReviewsScreen> {
  bool isFav = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 10.0),
            SizedBox(height: 10.0),
            Text(
              "${restos[1]['name']}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5.0, top: 2.0),
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
            SizedBox(height: 10.0),
            // Text(
            //   "Reviews",
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.w800,
            //   ),
            //   maxLines: 2,
            // ),
            Container(
              height: 88,
              //color: Cols.white,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 31,
                    bottom: 31,
                    left: 40,
                    child: Text(
                      "Reviews",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Positioned(
                    top: 18,
                    bottom: 18,
                    right: 24,
                    // child: FloatingActionButton(
                    //   tooltip: "Add a review",
                    //   child: Icon(
                    //     Icons.rate_review,
                    //   ),
                    // )
                    child: TapOpacity(
                        onTap: () {
                          openAlertBox();
                        },
                        child: Container(
                          width: 135,
                          height: 52,
                          decoration: BoxDecoration(
                              color: Colors.red[400],
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Cols.black.withOpacity(0.2),
                                    blurRadius: 24,
                                    offset: Offset(0, 8))
                              ]).copyWith(),
                          child: Center(
                              child: Text("Add",
                                  style: TextStyles.airbnbCerealMedium.copyWith(
                                      fontSize: 16, color: Cols.white))),
                        )),
                  )
                ],
              ),
            ),
            SizedBox(height: 20.0),
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10),
              shrinkWrap: true,
              primary: false,
              physics: NeverScrollableScrollPhysics(),
              itemCount: comments == null ? 0 : comments.length,
              itemBuilder: (BuildContext context, int index) {
                Map comment = comments[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  elevation: 1,
                  child: ListTile(
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
                  ),
                );
              },
            ),
            SizedBox(height: 10.0),
            // Container(
            //   height: 88,
            //   //color: Cols.white,
            //   child: Stack(
            //     children: <Widget>[
            //       // Positioned(
            //       //   top: 31,
            //       //   bottom: 31,
            //       //   left: 40,
            //       //   child: RichText(
            //       //       text: TextSpan(children: <TextSpan>[
            //       //     TextSpan(
            //       //         text: '\$',
            //       //         style: TextStyles.airbnbCerealMedium.copyWith(
            //       //             fontSize: 12,
            //       //             color: Cols.black.withOpacity(0.75))),
            //       //     TextSpan(
            //       //         //text: price.toStringAsFixed(2),
            //       //         style: TextStyles.airbnbCerealMedium
            //       //             .copyWith(fontSize: 20, color: Cols.black))
            //       //   ])),
            //       // ),
            //       Positioned(
            //         top: 18,
            //         bottom: 18,
            //         right: 24,
            //         // child: FloatingActionButton(
            //         //   tooltip: "Add a review",
            //         //   child: Icon(
            //         //     Icons.rate_review,
            //         //   ),
            //         // )
            //         child: TapOpacity(
            //             onTap: () {},
            //             child: Container(
            //               width: 135,
            //               height: 52,
            //               decoration: BoxDecoration(
            //                   color: Colors.red[400],
            //                   borderRadius: BorderRadius.circular(8),
            //                   boxShadow: <BoxShadow>[
            //                     BoxShadow(
            //                         color: Cols.blue.withOpacity(0.2),
            //                         blurRadius: 24,
            //                         offset: Offset(0, 8))
            //                   ]).copyWith(),
            //               child: Center(
            //                   child: Text("Review",
            //                       style: TextStyles.airbnbCerealMedium.copyWith(
            //                           fontSize: 16, color: Cols.white))),
            //             )),
            //       )
            //     ],
            //   ),
            // ),
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

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Rate",
                        style: TextStyle(fontSize: 24.0),
                      ),
                      // Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: <Widget>[
                      //     Icon(
                      //       Icons.star_border,
                      //       color: Colors.green,
                      //       size: 30.0,
                      //     ),
                      //     Icon(
                      //       Icons.star_border,
                      //       color: Colors.green,
                      //       size: 30.0,
                      //     ),
                      //     Icon(
                      //       Icons.star_border,
                      //       color: Colors.green,
                      //       size: 30.0,
                      //     ),
                      //     Icon(
                      //       Icons.star_border,
                      //       color: Colors.green,
                      //       size: 30.0,
                      //     ),
                      //     Icon(
                      //       Icons.star_border,
                      //       color: Colors.green,
                      //       size: 30.0,
                      //     ),
                      //   ],
                      // ),
                      SmoothStarRating(
                          allowHalfRating: true,
                          onRated: (v) {},
                          starCount: 5,
                          //rating: rating,
                          size: 40.0,
                          color: Constants.ratingBG,
                          isReadOnly: false,
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          borderColor: Constants.ratingBG,
                          spacing: 0.0)
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 4.0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Add Review",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(32.0),
                            bottomRight: Radius.circular(32.0)),
                      ),
                      child: Text(
                        "Rate Product",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
