import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Database/Authentication.dart';
import 'package:foodz_client/Screens/HomeScreen.dart';
import 'package:foodz_client/Screens/LoginScreen.dart';
import 'package:foodz_client/Screens/MainScreen.dart';
import 'package:foodz_client/utils/T3Constant.dart';
import 'package:foodz_client/utils/T3Images.dart';
import 'package:foodz_client/utils/colors.dart';
import 'package:foodz_client/utils/strings.dart';
import 'package:foodz_client/utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  static String tag = 'RegisterScreen';

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  String repeatPassword;
  String username;

  bool passwordVisible = false;
  bool isRemember = false;
  Authentication authentication = Authentication();

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height) / 3.5,
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      t3_ic_background,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            t3_lbl_create_account,
                            style: TextStyle(
                                fontSize: 34,
                                fontFamily: fontBold,
                                color: t3_white),
                          ),
                          SizedBox(height: 4),
                          Text(
                            t3_lbl_recipe_for_happiness,
                            style: TextStyle(
                                fontSize: 20,
                                fontFamily: fontBold,
                                color: t3_white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                  alignment: Alignment.topRight,
                  margin: EdgeInsets.only(right: 45),
                  transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                  child: Image.asset(
                    t3_ic_icon,
                    height: 70,
                    width: 70,
                  )),
              editTextStyle(t3_hint_Email,
                  isPassword: false,
                  type: TextInputType.emailAddress, onchange: (value) {
                email = value;
                //print(email);
              }),
              SizedBox(height: 16),

              editTextStyle("Username", isPassword: false, onchange: (value) {
                username = value;
                //print(email);
              }),

              SizedBox(height: 16),

              editTextStyle(t3_hint_password, isPassword: true,
                  onchange: (value) {
                password = value;
                //print(password);
              }),
              SizedBox(height: 16),
              editTextStyle(t3_hint_confirm_password, isPassword: true,
                  onchange: (value) {
                repeatPassword = value;
                //print(repeatPassword);
              }),
              SizedBox(height: 35),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: AppButton(
                    textContent: t3_lbl_sign_up,
                    onPressed: () async {
                      //print(email + " " + password + " " + repeatPassword);
                      if (email.trim() != null &&
                          password != null &&
                          password == repeatPassword &&
                          username.trim() != null) {
                        await authentication.classicSignUp(
                            context: context,
                            email: email.trim(),
                            password: password,
                            username: username.trim());
                      }
                    }),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  text(t3_lbl_already_have_account,
                      textColor: t3_textColorPrimary),
                  Container(
                    margin: EdgeInsets.only(left: 4),
                    child: GestureDetector(
                        child: Text(t3_lbl_sign_in,
                            style: TextStyle(
                              fontSize: textSizeLargeMedium,
                              decoration: TextDecoration.underline,
                              color: t3_colorPrimary,
                            )),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(context, LoginScreen.tag);
                        }),
                  )
                ],
              ),
              // Container(
              //   alignment: Alignment.bottomLeft,
              //   margin:
              //       EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 20),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Image.asset(
              //         t3_ic_sign2,
              //         height: 50,
              //         width: 70,
              //       ),
              //       Container(
              //           margin: EdgeInsets.only(top: 25, left: 10),
              //           child: Image.asset(
              //             t3_ic_sign4,
              //             height: 50,
              //             width: 70,
              //           )),
              //       Container(
              //           margin: EdgeInsets.only(top: 25, left: 10),
              //           child: Image.asset(
              //             t3_ic_sign3,
              //             height: 50,
              //             width: 70,
              //           )),
              //       Image.asset(
              //         t3_ic_sign1,
              //         height: 80,
              //         width: 80,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
