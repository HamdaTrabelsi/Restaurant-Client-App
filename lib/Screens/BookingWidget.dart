import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodz_client/Screens/NoAccountScreen.dart';
import 'package:foodz_client/Widgets/RoundIconButton.dart';
import 'package:foodz_client/Database/ReservationDB.dart';
import 'package:foodz_client/utils/ErrorFlushBar.dart';
import 'package:foodz_client/utils/SuccessFlushBar.dart';
import 'package:foodz_client/utils/Template/common.dart';
import 'package:date_format/date_format.dart';
import 'package:foodz_client/utils/colors.dart';
import 'package:intl/intl.dart';

final _auth = FirebaseAuth.instance;

class BookingWidget extends StatefulWidget {
  const BookingWidget({
    Key key,
    @required this.scrollController,
    @required this.restId,
  }) : super(key: key);
  final ScrollController scrollController;
  final String restId;
  @override
  _BookingWidgetState createState() => _BookingWidgetState();
}

class _BookingWidgetState extends State<BookingWidget> {
  //String _setTime, _setDate;

  bool _sent = false;
  bool _loading = false;
  String _hour = "", _minute = "", _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  int _people = 0;

  ReservationDB resDB = new ReservationDB();
  // TextEditingController _dateController = TextEditingController();
  // TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        //_dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        // _timeController.text = _time;
        // _timeController.text = formatDate(
        //     DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
        //     [hh, ':', nn, " ", am]).toString();
      });
  }

  @override
  void initState() {
    //_dateController.text = DateFormat.yMd().format(DateTime.now());

    // _timeController.text = formatDate(
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute),
    //     [hh, ':', nn, " ", am]).toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dateTime = DateFormat.yMd().format(DateTime.now());

    return Scaffold(
      body: ListView(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(25.0, 50, 25, 50),
        children: <Widget>[
          Row(
            children: [
              Container(
                child: Text(
                  'Book a table, Anytime',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.0),
          SizedBox(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How many people ?',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '$_people People',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
              ]),
              Row(
                children: [
                  RoundIconButton(
                    onPressed: () {
                      setState(() {
                        if (_people > 0) {
                          _people--;
                        }
                      });
                    },
                    icon: Icons.remove,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  RoundIconButton(
                    onPressed: () {
                      _people++;
                    },
                    icon: Icons.add,
                  )
                ],
              )
            ],
          ),
          Divider(height: 40.0),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'When',
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    DateFormat.yMd().format(selectedDate),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
            ]),
            RawMaterialButton(
              child: Icon(
                Icons.date_range,
                color: Colors.white,
              ),
              onPressed: () {
                _selectDate(context);
              },
              elevation: 6,
              constraints: BoxConstraints.tightFor(
                width: 120,
                height: 56,
              ),
              shape: StadiumBorder(),
              fillColor: kPrimaryColor,
            ),
          ]),
          Divider(height: 40.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Time',
                      style: TextStyle(fontSize: 13),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$_hour : $_minute",
                      // formatDate(
                      //     DateTime(2019, 08, 1, selectedTime.hour,
                      //         selectedTime.minute),
                      //     [hh, ':', nn, " ", am]).toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )
                  ],
                ),
              ]),
              RawMaterialButton(
                child: Icon(
                  Icons.timer,
                  color: Colors.white,
                ),
                onPressed: () {
                  _selectTime(context);
                },
                elevation: 6,
                constraints: BoxConstraints.tightFor(
                  width: 120,
                  height: 56,
                ),
                shape: StadiumBorder(),
                fillColor: kPrimaryColor,
              ),
            ],
          ),
          // TextField(
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'Where',
          //     icon: Container(
          //       width: 50.0,
          //       height: 50.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20.0),
          //         color: Color(0xFFEEF8FF),
          //       ),
          //       child: Icon(
          //         Icons.group,
          //         size: 25.0,
          //         color: Color(
          //           0xFF309DF1,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(height: 40.0),
          // TextField(
          //   onTap: () {
          //     _selectDate(context);
          //   },
          //   controller: _dateController,
          //   readOnly: true,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'Reservation Date',
          //     icon: Container(
          //       width: 50.0,
          //       height: 50.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20.0),
          //         color: Color(0xFFEEF8FF),
          //       ),
          //       child: Icon(
          //         Icons.calendar_today,
          //         size: 25.0,
          //         color: Color(
          //           0xFF309DF1,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Divider(height: 40.0),
          // TextField(
          //   onTap: () {
          //     _selectTime(context);
          //   },
          //   controller: _timeController,
          //   readOnly: true,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'Time',
          //     icon: Container(
          //       width: 50.0,
          //       height: 50.0,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(20.0),
          //         color: Color(0xFFEEF8FF),
          //       ),
          //       child: Icon(
          //         Icons.timer,
          //         size: 25.0,
          //         color: Color(
          //           0xFF309DF1,
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Divider(height: 40.0),
          FlatButton(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            //color: Color(0xFF309DF1),
            color: kPrimaryColor,
            child: _loading
                ? CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    _sent ? 'Awaiting approval' : 'Book',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            onPressed: _loading
                ? null
                : () {
                    if (_sent) {
                      SuccessFlush.showSuccessFlush(
                          context: context,
                          message: "Your reservation has already been sent !");
                    } else {
                      if (_people == 0) {
                        ErrorFlush.showErrorFlush(
                            context: context,
                            message:
                                "Number of people should be higher than 0");
                      } else if (_hour == null ||
                          _hour == "00" ||
                          _minute.isEmpty) {
                        ErrorFlush.showErrorFlush(
                            context: context, message: "Enter a valid time");
                      } else if (selectedDate
                          .difference(DateTime.now())
                          .inDays
                          .isNegative) {
                        ErrorFlush.showErrorFlush(
                            context: context, message: "Enter a valid Date");
                      } else {
                        _loading = true;
                        resDB
                            .addNewReservation(
                                restoId: widget.restId,
                                reservationTime: /*"$_hour : $_minute"*/ selectedTime
                                    .format(context)
                                    .toString(),
                                reservationDay: selectedDate,
                                people: _people.toString())
                            .onError((error, stackTrace) =>
                                ErrorFlush.showErrorFlush(
                                    context: context,
                                    message: error.toString()))
                            .whenComplete(() {
                          _sent = true;
                          SuccessFlush.showSuccessFlush(
                              context: context, message: "Reservation Sent !");
                        }).then((value) {
                          setState(() {
                            _loading = false;
                          });
                        });
                      }
                    }
                  },
          ),
          SizedBox(height: 30.0),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
