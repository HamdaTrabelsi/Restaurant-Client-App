import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/HomeScreen.dart';
import 'package:foodz_client/Screens/IntroScreen.dart';
import 'package:foodz_client/Screens/LoginScreen.dart';
import 'package:foodz_client/Screens/RegisterScreen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'Screens/Welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      initialRoute: IntroScreen.tag,
      routes: {
        IntroScreen.tag: (context) => IntroScreen(),
        WelcomeScreen.tag: (context) => WelcomeScreen(),
        LoginScreen.tag: (context) => LoginScreen(),
        RegisterScreen.tag: (context) => RegisterScreen(),
        HomeScreen.tag: (context) => HomeScreen(),
      },
    );
  }
}
