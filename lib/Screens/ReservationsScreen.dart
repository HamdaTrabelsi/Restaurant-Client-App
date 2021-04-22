import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/CheckoutScreen.dart';
import 'package:foodz_client/utils/Template/Restaurants.dart';
//import 'package:foodz_client/Screens/checkout.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/ReservItem.dart';
import 'package:foodz_client/Widgets/DismissibleWidget.dart';
import 'package:foodz_client/utils/Util.dart';

class ReservationsScreen extends StatefulWidget {
  static String tag = '/ReservationsScreen';

  @override
  _ReservationsScreen createState() => _ReservationsScreen();
}

class _ReservationsScreen extends State<ReservationsScreen>
    with AutomaticKeepAliveClientMixin<ReservationsScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Reservations"),
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: restos == null ? 0 : restos.length,
          itemBuilder: (BuildContext context, int index) {
//                Food food = Food.fromJson(foods[index]);
            Map rest = restos[index];
//                print(foods);
//                print(foods.length);
            return DismissibleWidget(
              item: rest,
              ondismissed: (direction) {
                dismissItem(context, index, direction);
              },
              child: ReserveItem(
                img: rest['img'],
                isFav: false,
                name: rest['name'],
                rating: 5.0,
                raters: 23,
              ),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   tooltip: "Checkout",
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (BuildContext context) {
      //           return CheckoutScreen();
      //           return CheckoutScreen();
      //         },
      //       ),
      //     );
      //   },
      //   child: Icon(
      //     Icons.arrow_forward,
      //   ),
      //   heroTag: Object(),
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void dismissItem(
      BuildContext context, int index, DismissDirection direction) {
    setState(() {
      restos.removeAt(index);
    });
    Util.showSnackBar(context, 'This reservation has been cancelled');
  }
}
