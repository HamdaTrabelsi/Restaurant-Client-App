import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodz_client/Models/Dish.dart';
import 'package:foodz_client/utils/colors.dart';

class PlateDetailsScreen extends StatefulWidget {
  static String tag = '/FoodDetailsScreen';

  @override
  _PlateDetailsScreenState createState() => _PlateDetailsScreenState();
}

class _PlateDetailsScreenState extends State<PlateDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final plateId = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('dishes').doc(plateId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
          if (snapshot.data.exists) {
            Dish dish = Dish.fromJson(snapshot.data.data());
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)
                          /*SvgPicture.asset(
                      "assets/icons/backward.svg",
                      height: 11,
                    ),*/
                          ),
                      //Icon(Icons.menu),
                      /*SvgPicture.asset(
                    "assets/icons/menu.svg",
                    height: 11,
                  ),*/
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.all(6),
                    height: 305,
                    width: 305,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: kSecondaryColor,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(dish.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "${dish.name}\n",
                              style: Theme.of(context).textTheme.title,
                            ),
                            TextSpan(
                              text: dish.cuisine,
                              style: TextStyle(
                                color: kTextColor.withOpacity(.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\ ${dish.price} Dt",
                        style: Theme.of(context)
                            .textTheme
                            .headline
                            .copyWith(color: kPrimaryColor),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(dish.description),
                  Spacer(),
                  // Padding(
                  //   padding: EdgeInsets.only(bottom: 30),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27),
                  //         decoration: BoxDecoration(
                  //           color: kPrimaryColor.withOpacity(.19),
                  //           borderRadius: BorderRadius.circular(27),
                  //         ),
                  //         child: Row(
                  //           children: <Widget>[
                  //             Text(
                  //               "Add to bag",
                  //               style: Theme.of(context).textTheme.button,
                  //             ),
                  //             SizedBox(width: 30),
                  //             // SvgPicture.asset(
                  //             //   "assets/icons/forward.svg",
                  //             //   height: 11,
                  //             // ),
                  //             Icon(Icons.arrow_forward)
                  //           ],
                  //         ),
                  //       ),
                  //       Container(
                  //         height: 80,
                  //         width: 80,
                  //         decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: kPrimaryColor.withOpacity(.26),
                  //         ),
                  //         child: Stack(
                  //           alignment: Alignment.center,
                  //           children: <Widget>[
                  //             Container(
                  //               padding: EdgeInsets.all(15),
                  //               height: 60,
                  //               width: 60,
                  //               decoration: BoxDecoration(
                  //                 shape: BoxShape.circle,
                  //                 color: kPrimaryColor,
                  //               ),
                  //               //child: SvgPicture.asset("assets/icons/bag.svg"),
                  //             ),
                  //             Positioned(
                  //               right: 15,
                  //               bottom: 10,
                  //               child: Container(
                  //                 alignment: Alignment.center,
                  //                 height: 28,
                  //                 width: 28,
                  //                 decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: kWhiteColor,
                  //                 ),
                  //                 child: Text(
                  //                   "0",
                  //                   style: Theme.of(context)
                  //                       .textTheme
                  //                       .button
                  //                       .copyWith(color: kPrimaryColor, fontSize: 16),
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                ],
              ),
            );
          } else {
            return Center(child: Container(child: Text("Dish doesn't exist")));
          }
        },
      ),
    );
  }
}
