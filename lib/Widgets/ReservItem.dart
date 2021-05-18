import 'package:flutter/material.dart';

class ReserveItem extends StatelessWidget {
  final String name;
  final String img;
  final String date;
  final String time;
  final String seats;
  //final bool isFav;
  //final double rating;
  //final int raters;

  ReserveItem({
    Key key,
    @required this.name,
    @required this.img,
    @required this.date,
    @required this.time,
    @required this.seats,
    //@required this.isFav,
    //@required this.rating,
    //@required this.raters,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: InkWell(
        // onTap: () {
        //   Navigator.of(context).push(
        //     MaterialPageRoute(
        //       builder: (BuildContext context) {
        //         return DetailsScreen();
        //       },
        //     ),
        //   );
        // },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Container(
                  height: MediaQuery.of(context).size.width / 4,
                  width: MediaQuery.of(context).size.width / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      "$img",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "$name",
                        style: TextStyle(
//                    fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Text(
                            "Seats",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            "$seats",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Made 5 min ago",
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            "Date",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            "$date",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Text(
                            "Time",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            "$time",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
