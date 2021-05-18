import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodz_client/Screens/MainScreen.dart';
import 'package:foodz_client/Screens/Welcome.dart';
import 'package:foodz_client/utils/Template/common.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/cart_item.dart';

class NoAccountScreen extends StatefulWidget {
  static String tag = '/noAccountScreen';

  @override
  _NoAccountScreen createState() => _NoAccountScreen();
}

class _NoAccountScreen extends State<NoAccountScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: Container(color: Colors.white)),
      body: Align(
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
                  Image.asset("images/restaurant/security-code.png",
                      width: 250, height: 200),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Whoops!",
                      style: TextStyle(
                          fontSize: 30,
                          color: Constants.lightAccent,
                          fontWeight: FontWeight.bold)),
                  Container(height: 10),
                  Text("You need an account to access this feature",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.lightAccent,
                      )),
                  Container(height: 25),
                  Container(
                    width: 180,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Constants.lightAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, WelcomeScreen.tag);
                      },
                      child:
                          Text("Login", style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
