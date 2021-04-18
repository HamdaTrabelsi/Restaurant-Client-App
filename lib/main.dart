import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/CartScreen.dart';
import 'package:foodz_client/Screens/CategoriesScreen.dart';
import 'package:foodz_client/Screens/CheckoutScreen.dart';
import 'package:foodz_client/Screens/DetailsScreen.dart';
import 'package:foodz_client/Screens/DishesScreen.dart';
import 'package:foodz_client/Screens/FavouriteScreen.dart';
import 'package:foodz_client/Screens/HomeScreen.dart';
import 'package:foodz_client/Screens/IntroScreen.dart';
import 'package:foodz_client/Screens/LoginScreen.dart';
import 'package:foodz_client/Screens/MainScreen.dart';
import 'package:foodz_client/Screens/NotificationScreen.dart';
import 'package:foodz_client/Screens/ProfileScreen.dart';
import 'package:foodz_client/Screens/RegisterScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:foodz_client/Screens/SearchScreen.dart';
import 'package:foodz_client/provider/app_provider.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:provider/provider.dart';

import 'Screens/Welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, AppProvider appProvider, Widget child) {
      return MaterialApp(
        //theme: ThemeData.dark(),
        key: appProvider.key,
        debugShowCheckedModeBanner: false,
        navigatorKey: appProvider.navigatorKey,
        title: Constants.appName,
        theme: appProvider.theme,
        darkTheme: Constants.darkTheme,
        initialRoute: IntroScreen.tag,
        routes: {
          IntroScreen.tag: (context) => IntroScreen(),
          WelcomeScreen.tag: (context) => WelcomeScreen(),
          LoginScreen.tag: (context) => LoginScreen(),
          RegisterScreen.tag: (context) => RegisterScreen(),
          HomeScreen.tag: (context) => HomeScreen(),
          MainScreen.tag: (context) => MainScreen(),
          CartScreen.tag: (context) => CartScreen(),
          CategoriesScreen.tag: (context) => CategoriesScreen(),
          CheckoutScreen.tag: (context) => CheckoutScreen(),
          DetailsScreen.tag: (context) => DetailsScreen(),
          DishesScreen.tag: (context) => DishesScreen(),
          FavouriteScreen.tag: (context) => FavouriteScreen(),
          NotificationScreen.tag: (context) => NotificationScreen(),
          ProfileScreen.tag: (context) => ProfileScreen(),
          SearchScreen.tag: (context) => SearchScreen(),
        },
      );
    });
  }
}
