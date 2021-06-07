import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Models/Restaurant.dart';
import 'package:foodz_client/Screens/DetailsScreen.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:foodz_client/utils/Template/foods.dart';
import 'package:foodz_client/Widgets/smooth_star_rating.dart';

List<Restaurant> _listRest = [];

class SearchScreen extends StatefulWidget {
  static String tag = '/SearchScreen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with AutomaticKeepAliveClientMixin<SearchScreen> {
  final CollectionReference searchRef =
      FirebaseFirestore.instance.collection("restaurant");
  final TextEditingController _searchControl = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10.0),
          Card(
            elevation: 6.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Search..",
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: _searchControl,
                onChanged: (res) {
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Latest",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          StreamBuilder(
            stream: searchRef
                //.where("title", isGreaterThanOrEqualTo: _searchControl.text)
                //.where("title", isLessThan: _searchControl.text + 'z')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Container(child: CircularProgressIndicator()));
              }
              if (snapshot.data.docs.isNotEmpty) {
                _listRest.clear();
                snapshot.data.docs.forEach((element) {
                  _listRest.add(Restaurant.fromJson(element));
                });

                return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _listRest == null ? 0 : _listRest.length,
                    itemBuilder: (BuildContext context, int index) {
                      Restaurant resto = _listRest[index];
                      if (_listRest[index]
                          .title
                          .toLowerCase()
                          .contains(_searchControl.text.toLowerCase())) {
                        return ListTile(
                          title: Text(
                            resto.title,
                            style: TextStyle(
                              //                    fontSize: 15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage(
                              resto.image,
                            ),
                          ),
                          //trailing: Text(r"$10"),
                          subtitle: Row(
                            children: <Widget>[
                              StarRating(
                                starCount: 1,
                                color: Constants.ratingBG,
                                allowHalfRating: true,
                                rating: 5.0,
                                size: 12.0,
                              ),
                              SizedBox(width: 6.0),
                              Text(
                                "5.0 (23 Reviews)",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushNamed(context, DetailsScreen.tag,
                                arguments: resto.uid);
                          },
                        );
                      } else {
                        return Container();
                      }
                    });
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
                            Text("No result !",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Constants.lightAccent,
                                    fontWeight: FontWeight.bold)),
                            Container(height: 10),
                            Text("Make some !",
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
            },
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
