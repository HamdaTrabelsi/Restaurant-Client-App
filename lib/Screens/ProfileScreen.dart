import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:foodz_client/Database/Authentication.dart';
import 'package:foodz_client/Database/UserDB.dart';
import 'package:foodz_client/Screens/NavigationScreen.dart';
import 'package:foodz_client/provider/app_provider.dart';
import 'package:foodz_client/utils/Template/const.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sweetsheet/sweetsheet.dart';

final _firestore = FirebaseFirestore.instance;
final _origin =
    WayPoint(name: "Way Point 1", latitude: 37.273276, longitude: 9.870051);
User loggedInUser;
final googleSignIn = GoogleSignIn();
final _auth = FirebaseAuth.instance;
Authentication authentication = Authentication();
UserDB _userDB = UserDB();
User myUser = _auth.currentUser;
final SweetSheet _sweetSheet = SweetSheet();

class ProfileScreen extends StatefulWidget {
  static String tag = '/ProfileScreen';

  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  File _image;
  final _picker = ImagePicker();
  bool _isLoading = false;
  bool _isDisabled = false;

  String newName = "";
  String newAddress = "";
  String newPhone = "";

  var nameCont = TextEditingController();
  var addressCont = TextEditingController();
  var phoneCont = TextEditingController();

  var dateCont = TextEditingController();

  var oldPassCont = TextEditingController();
  var newPassCont = TextEditingController();
  var repPassCont = TextEditingController();

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              body: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: ((builder) => imageBottomSheet()),
                              );
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            offset: Offset(0, 10))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: _image == null
                                            ? snapshot.data["image"] == ""
                                                ? AssetImage(
                                                    "images/restaurant/empty.png")
                                                : NetworkImage(
                                                    snapshot.data["image"])
                                            : FileImage(File(_image.path)),
                                        // _image == null
                                        //     ? AssetImage("images/offline/empty.png")
                                        //     : FileImage(File(_image.path)),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                          color: Theme.of(context).accentColor,
                                          width: 2)),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 4,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                        ),
                                        color: Theme.of(context).accentColor,
                                      ),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    /*"Jane Doe"*/ snapshot.data["username"]
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  MaterialButton(
                                    disabledColor:
                                        Theme.of(context).accentColor,
                                    height: 40,
                                    child: _isLoading == true
                                        ? Container(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                        : Icon(Icons.save),
                                    onPressed: _isDisabled == true
                                        ? null
                                        : () async {
                                            if (_image != null) {
                                              setState(() {
                                                _isDisabled = true;
                                                _isLoading = true;
                                              });

                                              String res =
                                                  await _userDB.storeUserImage(
                                                      upImage: _image,
                                                      context: context,
                                                      id: snapshot.data["uid"]);
                                              await _userDB.savePicUrl(
                                                  id: snapshot.data["uid"],
                                                  url: res,
                                                  context: context);

                                              setState(() {
                                                _isLoading = false;
                                                _isDisabled = false;
                                              });
                                            }
                                          },
                                    color: Theme.of(context).accentColor,
                                    textColor: Colors.white,
                                    minWidth: 20,
                                  ),

                                  // Text(
                                  //   snapshot.data["email"],
                                  //   style: TextStyle(
                                  //     fontSize: 14.0,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 20.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // InkWell(
                                  //   onTap: () async {
                                  //     await authentication.signOut(
                                  //         context: context);
                                  //     // Navigator.pushNamed(context, WelcomeScreen.tag);
                                  //   },
                                  //   child: Text(
                                  //     "Logout",
                                  //     style: TextStyle(
                                  //       fontSize: 13.0,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: Theme.of(context).accentColor,
                                  //     ),
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          flex: 3,
                        ),
                      ],
                    ),
                    Divider(),
                    Container(height: 15.0),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        "Account Information".toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        //"jane@doefamily.com",
                        //loggedInUser.email,
                        snapshot.data["email"],
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Full Name",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data["username"],
                        //loggedInUser.displayName,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Name",
                                kbtype: TextInputType.name,
                                //newValue: newName,
                                field: "username",
                                contex: builder,
                                cont: nameCont,
                                uid: snapshot.data["uid"])),
                          );
                        },
                        tooltip: "Edit",
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Address",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Address",
                                kbtype: TextInputType.streetAddress,
                                //newValue: newName,
                                field: "address",
                                contex: builder,
                                cont: addressCont,
                                uid: snapshot.data["uid"])),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["address"] != ""
                            ? snapshot.data["address"]
                            : "No address yet",
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Phone",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => textBottomSheet(
                                text: "Edit Phone",
                                kbtype: TextInputType.phone,
                                //newValue: newName,
                                field: "phone",
                                contex: builder,
                                cont: phoneCont,
                                uid: snapshot.data["uid"])),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["phone"] != ""
                            ? snapshot.data["phone"]
                            : "No phone Number yet",
                      ),
                    ),

                    // ListTile(
                    //   title: Text(
                    //     "Gender",
                    //     style: TextStyle(
                    //       fontSize: 17,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    //   trailing: IconButton(
                    //     icon: Icon(
                    //       Icons.edit,
                    //       size: 20.0,
                    //     ),
                    //     onPressed: () {
                    //       showModalBottomSheet(
                    //         isScrollControlled: true,
                    //         context: context,
                    //         builder: ((builder) => textBottomSheet(
                    //             text: "Edit Gender",
                    //             fieldType: "text",
                    //             onPress: () {})),
                    //       );
                    //     },
                    //     tooltip: "Edit",
                    //   ),
                    //   subtitle: Text(
                    //     snapshot.data["gender"] != ""
                    //         ? snapshot.data["gender"]
                    //         : "Add Gender",
                    //   ),
                    // ),
                    ListTile(
                      title: Text(
                        "Date of Birth",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 20.0,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((builder) => dateBottomSheet(
                                text: "Edit BirthDate",
                                contex: builder,
                                datecont: dateCont,
                                uid: snapshot.data["uid"])),
                          );
                        },
                        tooltip: "Edit",
                      ),
                      subtitle: Text(
                        snapshot.data["birthDate"] != null
                            ? DateFormat('dd MMMM yyyy')
                                .format(snapshot.data["birthDate"].toDate())
                                .toString()
                            : "No Birth Date",
                      ),
                    ),
                    loggedInUser.providerData[0].providerId == "password"
                        ? ListTile(
                            title: Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 20.0,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: ((builder) => passwordBottomSheet(
                                      text: "Edit Password",
                                      //kbtype: TextInputType.visiblePassword,
                                      //newValue: newName,
                                      //field: "Change Password",
                                      contex: builder,
                                      newpassCont: newPassCont,
                                      oldpassCont: oldPassCont,
                                      reppassCont: repPassCont,
                                      uid: snapshot.data["uid"])),
                                );
                              },
                              tooltip: "Edit",
                            ),
                            subtitle: Text("Change Password"),
                          )
                        : SizedBox(
                            height: 5,
                          ),

                    MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? SizedBox()
                        : ListTile(
                            title: Text(
                              "Dark Theme",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            trailing: Switch(
                              value: Provider.of<AppProvider>(context).theme ==
                                      Constants.lightTheme
                                  ? false
                                  : true,
                              onChanged: (v) async {
                                if (v) {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.darkTheme, "dark");
                                } else {
                                  Provider.of<AppProvider>(context,
                                          listen: false)
                                      .setTheme(Constants.lightTheme, "light");
                                }
                              },
                              activeColor: Theme.of(context).accentColor,
                            ),
                          ),
                    ListTile(
                      title: Text(
                        "Sign Out",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.red),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.logout,
                          size: 20.0,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          //await authentication.signOut(context: context);
                          _sweetSheet.show(
                            context: context,
                            //title: Text("Logout ?"),
                            description: Text(
                                'Do you want to sign out of your account ?'),
                            color: SweetSheetColor.DANGER,
                            icon: Icons.logout,
                            positive: SweetSheetAction(
                              onPressed: () async {
                                await authentication.signOut(context: context);
                              },
                              title: 'Confirm',
                              //icon: Icons.open_in_new,
                            ),
                            negative: SweetSheetAction(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              title: 'Cancel',
                            ),
                          );
                        },
                        tooltip: "Logout",
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Container(child: CircularProgressIndicator()));
          }
        });
  }

  Widget imageBottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose a Profile Photo",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.camera),
                label: Text("Camera"),
              ),
              FlatButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(Icons.image),
                label: Text("Gallery"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget textBottomSheet(
      {
      //@required String newValue,
      @required String field,
      @required String text,
      //@required Function onPress,
      @required TextInputType kbtype,
      @required String uid,
      BuildContext contex,
      TextEditingController cont}) {
    return StatefulBuilder(
        builder: (contex, StateSetter setModalState /*You can rename this!*/) {
      return AnimatedPadding(
          padding: MediaQuery.of(contex).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                      GestureDetector(
                        child: Icon(Icons.check),
                        onTap: cont.text.trim() != ""
                            ? () async {
                                await _userDB.editTextField(
                                    id: uid,
                                    field: field,
                                    newValue: cont.text,
                                    context: context);
                                Navigator.pop(context);
                              }
                            : null,
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      /*text*/ /*newValue*/ text,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: cont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    keyboardType: kbtype,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Full Name"),
                  ),
                ],
              )));
    });
  }

  Widget passwordBottomSheet({
    //@required String newValue,
    //@required String field,
    @required String text,
    //@required Function onPress,
    //@required TextInputType kbtype,
    @required String uid,
    BuildContext contex,
    TextEditingController oldpassCont,
    TextEditingController newpassCont,
    TextEditingController reppassCont,
  }) {
    return StatefulBuilder(
        builder: (contex, StateSetter setModalState /*You can rename this!*/) {
      return AnimatedPadding(
          padding: MediaQuery.of(contex).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                      GestureDetector(
                          child: Icon(Icons.check),
                          onTap: oldPassCont.text.trim() != "" &&
                                  newPassCont.text.trim() != ""
                              ? () async {
                                  await _userDB.editPassword(
                                      oldPass: oldPassCont.text,
                                      newPass: newPassCont.text,
                                      repPass: repPassCont.text,
                                      context: context);
                                  // Navigator.pop(context);
                                }
                              : null),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      /*text*/ /*newValue*/ text,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: oldPassCont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    //keyboardType: kbtype,
                    autofocus: true,
                    obscureText: true,
                    decoration: InputDecoration(labelText: "Old Password"),
                  ),
                  TextField(
                    controller: newPassCont,
                    obscureText: true,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    //keyboardType: kbtype,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "New Password"),
                  ),
                  TextField(
                    obscureText: true,
                    controller: repPassCont,
                    onChanged: (value) {
                      setModalState(() {
                        //cont.text = value;
                      });
                    },
                    //keyboardType: kbtype,
                    autofocus: true,
                    decoration: InputDecoration(labelText: "Repeat Password"),
                  ),
                ],
              )));
    });
  }

  Widget dateBottomSheet({
    @required String text,
    @required TextEditingController datecont,
    @required String uid,
    @required BuildContext contex,
  }) {
    return StatefulBuilder(
        builder: (contex, StateSetter setModalState /*You can rename this!*/) {
      return AnimatedPadding(
          padding: MediaQuery.of(contex).viewInsets,
          duration: const Duration(milliseconds: 100),
          curve: Curves.decelerate,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () {
                            Navigator.pop(context);
                          }),
                      GestureDetector(
                        child: Icon(Icons.check),
                        onTap: dateCont.text.trim() != ""
                            ? () async {
                                await _userDB.editBirthdateField(
                                    id: uid,
                                    newValue: DateTime.parse(dateCont.text),
                                    context: context);
                                Navigator.pop(context);
                              }
                            : null,
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Text(
                      /*text*/ /*newValue*/ text,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: CupertinoDatePicker(
                      minimumYear: 1930,
                      maximumYear: DateTime.now().year,
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (value) {
                        setModalState(() {
                          dateCont.text = value.toString();
                        });
                      },
                    ),
                  ),
                ],
              )));
    });
  }

  void takePhoto(ImageSource source) async {
    final pickedImage = await _picker.getImage(
      source: source,
    );
    setState(() {
      _image = File(pickedImage.path);
    });
  }
}
