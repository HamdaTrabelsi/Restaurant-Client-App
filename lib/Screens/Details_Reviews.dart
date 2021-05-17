import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Database/ReviewDB.dart';
import 'package:foodz_client/Models/Review.dart';
import 'package:foodz_client/Models/Utilisateur.dart';
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
import 'package:intl/intl.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

ReviewDB revDB = new ReviewDB();
final _auth = FirebaseAuth.instance;
User _loggedInUser;

class ReviewsScreen extends StatefulWidget {
  static String tag = '/DetailsReviewsScreen';
  final String restoId;
  const ReviewsScreen({Key key, this.restoId}) : super(key: key);
  @override
  _ReviewsScreen createState() => _ReviewsScreen();
}

class _ReviewsScreen extends State<ReviewsScreen> {
  TextEditingController _descController = new TextEditingController();
  double _stars;
  double _initstars = 0;
  List<Review> _reviews = [];
  bool isFav = false;

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
            _loggedInUser != null
                ? StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('review')
                        .where("uid",
                            isEqualTo: _loggedInUser.uid + widget.restoId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child:
                                Container(child: CircularProgressIndicator()));
                      }
                      if (snapshot.data.docs.isNotEmpty) {
                        Review rev = Review.fromJson(snapshot.data.docs[0]);
                        _descController.text = rev.description;
                        _initstars = rev.stars;
                        return Column(
                          children: [
                            Container(
                              height: 88,
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
                                  reviewButton(
                                      ontap: () {
                                        openAlertBox(
                                            ontap: () {
                                              revDB
                                                  .editReview(
                                                      restoId: widget.restoId,
                                                      description:
                                                          _descController.text,
                                                      stars: _stars)
                                                  .whenComplete(() =>
                                                      Navigator.pop(context));
                                            },
                                            text: "Edit Review");
                                      },
                                      text: "Edit"),
                                ],
                              ),
                            ),
                            ReviewCard(rev: rev),
                          ],
                        );
                      } else {
                        return Container(
                          height: 88,
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
                              reviewButton(
                                  ontap: () {
                                    openAlertBox(
                                        ontap: () {
                                          revDB
                                              .addNewReview(
                                                  restoId: widget.restoId,
                                                  description:
                                                      _descController.text,
                                                  stars: _stars)
                                              .whenComplete(
                                                  () => Navigator.pop(context));
                                        },
                                        text: "Rate Product");
                                  },
                                  text: "Add"),
                            ],
                          ),
                        );
                      }
                    },
                  )
                : SizedBox(
                    height: 20,
                  ),
            SizedBox(height: 10.0),
            Divider(),
            FutureBuilder(
                future: _loggedInUser != null
                    ? FirebaseFirestore.instance
                        .collection('review')
                        .where("restoId", isEqualTo: widget.restoId)
                        .where("userId", isNotEqualTo: _loggedInUser.uid)
                        .get()
                    : FirebaseFirestore.instance
                        .collection('review')
                        .where("restoId", isEqualTo: widget.restoId)
                        .get(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: Container(child: CircularProgressIndicator()));
                  }
                  if (snapshot.data.docs.isNotEmpty) {
                    _reviews.clear();
                    snapshot.data.docs.forEach((element) {
                      _reviews.add(Review.fromJson(element));
                    });
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      shrinkWrap: true,
                      primary: false,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _reviews == null ? 0 : _reviews.length,
                      itemBuilder: (BuildContext context, int index) {
                        Review rev = _reviews[index];
                        return ReviewCard(rev: rev);
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
                                  height: 50,
                                ),
                                // Image.asset("images/offline/serving-dish.png",
                                //     width: 230, height: 120),
                                SizedBox(
                                  height: 20,
                                ),
                                Text("No reviews !",
                                    style: TextStyle(
                                        fontSize: 30,
                                        color: Constants.lightAccent,
                                        fontWeight: FontWeight.bold)),
                                Container(height: 10),
                                Text(
                                    "This restaurant doesn't have reviews yet !",
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

  Positioned reviewButton(
      {@required Function ontap, @required String text, Color color}) {
    return Positioned(
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
        onTap: ontap,
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
              child: Text(text,
                  style: TextStyles.airbnbCerealMedium
                      .copyWith(fontSize: 16, color: Cols.white))),
        ),
      ),
    );
  }

  openAlertBox({@required Function ontap, @required String text}) {
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
                          onRated: (v) {
                            setState(() {
                              _stars = v;
                            });
                          },
                          rating: _initstars,
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
                      controller: _descController,
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
                          text,
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      onTap: ontap),
                ],
              ),
            ),
          );
        });
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({
    Key key,
    @required this.rev,
  }) : super(key: key);

  final Review rev;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 1,
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(rev.userId)
            .get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
          Utilisateur user = Utilisateur.fromJson(snapshot.data.data());
          return ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                user.image,
              ),
            ),
            title: Text("me"),
            subtitle: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    StarRating(
                      starCount: 5,
                      color: Constants.ratingBG,
                      allowHalfRating: true,
                      rating: rev.stars,
                      size: 12.0,
                    ),
                    SizedBox(width: 6.0),
                    Text(
                      DateFormat.yMMMd().add_jm().format(rev.posted.toDate()),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 7.0),
                Text(
                  rev.description,
                ),
              ],
            ),
          );
        },
        // child: ListTile(
        //   leading: CircleAvatar(
        //     radius: 25.0,
        //     backgroundImage: AssetImage(
        //       "",
        //     ),
        //   ),
        //   title: Text("me"),
        //   subtitle: Column(
        //     children: <Widget>[
        //       Row(
        //         children: <Widget>[
        //           StarRating(
        //             starCount: 5,
        //             color: Constants.ratingBG,
        //             allowHalfRating: true,
        //             rating: rev.stars,
        //             size: 12.0,
        //           ),
        //           SizedBox(width: 6.0),
        //           Text(
        //             rev.posted.toDate().toString(),
        //             style: TextStyle(
        //               fontSize: 12,
        //               fontWeight: FontWeight.w300,
        //             ),
        //           ),
        //         ],
        //       ),
        //       SizedBox(height: 7.0),
        //       Text(
        //         rev.description,
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
