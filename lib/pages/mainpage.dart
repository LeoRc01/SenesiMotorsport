import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/main.dart';
import 'package:redsracing/pages/chronoPage.dart';
import 'package:redsracing/pages/strategy.dart';
import 'package:redsracing/sign/loginpage.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:redsracing/storage_engines/create_engine.dart';
import 'package:redsracing/storage_setups/savedsetups.dart';
import 'package:redsracing/storage_setups/savesetup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

  var time = "7:00";
  var fuel = "23";
  var size = "123";

  var result = "8:24";

  @override
  void initState() {
    getUID();
    super.initState();
  }

  getUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Constants.myUID = prefs.getString("UID");
  }

  @override
  Widget build(BuildContext context) {
    calculate(time, fuel, size);
    final safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

    final fourfiveHeight = (safeAreaHeight / 5) * 4;
    final onefiveHeight = (safeAreaHeight / 5);
    final width = MediaQuery.of(context).size.width;

    final twoeight = (fourfiveHeight / 8) * 2;
    final foureight = (fourfiveHeight / 8) * 4;

    TextEditingController controller = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.signOutAlt),
          onPressed: () async {
            if (Platform.isIOS) {
              showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: new Text("Log out?"),
                      content: new Text("Are you sure you want to log out?"),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          textStyle: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          isDefaultAction: true,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                        CupertinoDialogAction(
                          child: Text("Logout"),
                          textStyle: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                          onPressed: () async {
                            Navigator.pop(context);
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool("login", false);
                            prefs.setString("UID", "");
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  });
            } else {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        backgroundColor: darkColor,
                        elevation: 16,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        content: Container(
                          height: safeAreaHeight / 4.5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Log out?",
                                  style: GoogleFonts.montserrat(
                                      fontSize: width * 0.07,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text("Are you sure you want to log out?",
                                  style: GoogleFonts.montserrat(
                                      fontSize: width * 0.03,
                                      color: Colors.white)),
                              Container(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.blue),
                                      ),
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          Navigator.pop(context);
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setBool("login", false);
                                          prefs.setString("UID", "");
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginPage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Logout",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.red),
                                        )),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ));
                  });
            }

            /**/
          },
          color: Colors.white,
        ),
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Runtime", style: GoogleFonts.montserrat()),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.save,
                color: Colors.white,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                if (prefs.getString("UID") == "GUEST") {
                  if (Platform.isIOS) {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: new Text("Warning!"),
                            content: new Text("You need to be signed in."),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                textStyle: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                                isDefaultAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancel"),
                              ),
                              CupertinoDialogAction(
                                child: Text("Sign up"),
                                textStyle: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("login", false);
                                  prefs.setString("UID", "");
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        });
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              backgroundColor: darkColor,
                              elevation: 16,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              content: Container(
                                height: safeAreaHeight / 4.5,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text("Warning",
                                        style: GoogleFonts.montserrat(
                                            fontSize: width * 0.07,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    Text("You need to be signed in.",
                                        style: GoogleFonts.montserrat(
                                            fontSize: width * 0.03,
                                            color: Colors.white)),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                              style: GoogleFonts.montserrat(
                                                  color: Colors.blue),
                                            ),
                                          ),
                                          GestureDetector(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                SharedPreferences prefs =
                                                    await SharedPreferences
                                                        .getInstance();
                                                prefs.setBool("login", false);
                                                prefs.setString("UID", "");
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        RegisterPage(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                "Sign up",
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.red),
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        });
                  }
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SavedSetups()));
                }
              }),
          IconButton(
            icon: FaIcon(
              FontAwesomeIcons.plus,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateEngine()));
            },
          )
        ],
      ),
      backgroundColor: Color.fromRGBO(255, 0, 0, 1),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              width: width,
              height: fourfiveHeight -
                  MediaQuery.of(context).padding.top -
                  width * 0.11,
              child: Container(
                decoration: BoxDecoration(
                  color: darkColor,
                ),
                child: Column(
                  children: [
                    Container(
                      //padding: EdgeInsets.symmetric(vertical: 10),
                      width: width,
                      height: twoeight / 2,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: width,
                            height: (twoeight / 2),
                            child: Center(
                              child: Image.asset(
                                "assets/redslogo.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width,
                      height: foureight,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Stack(
                              textDirection: TextDirection.rtl,
                              children: [
                                Container(
                                  width: width,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: darkLighterColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        textDirection: TextDirection.ltr,
                                        children: [
                                          Container(
                                            width: width / 2 - 30,
                                            //color: Colors.red,
                                            height: (foureight / 3) - 15,
                                            child: Center(
                                              child: Container(
                                                width: width / 2 - 60,
                                                height: (foureight / 3) - 15,
                                                child: Center(
                                                  child: TextFormField(
                                                    cursorColor: mainColor,
                                                    maxLength: 5,
                                                    textAlign: TextAlign.center,
                                                    initialValue: time,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: "",
                                                      counterStyle: TextStyle(
                                                          fontSize: 0),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        time = value;
                                                        calculate(
                                                            time, fuel, size);
                                                      });
                                                    },
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize:
                                                          ((foureight / 3) -
                                                                  15) *
                                                              0.45,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 2,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.stopwatch,
                                          size: width * 0.13,
                                          color: darkColor,
                                        ),
                                        Text(
                                          "Elapsed Time [min]",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.027,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Stack(
                              children: [
                                Container(
                                  width: width,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: darkLighterColor,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Container(
                                            width: width / 2 - 30,
                                            //color: Colors.red,
                                            height: (foureight / 3) - 15,
                                            child: Center(
                                              child: Container(
                                                width: width / 2 - 60,
                                                height: (foureight / 3) - 15,
                                                child: Center(
                                                  child: TextFormField(
                                                    cursorColor: mainColor,
                                                    textAlign: TextAlign.center,
                                                    initialValue: fuel,
                                                    maxLength: 3,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: "",
                                                      counterStyle: TextStyle(
                                                          fontSize: 0),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        fuel = value;
                                                        calculate(
                                                            time, fuel, size);
                                                      });
                                                    },
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize:
                                                          ((foureight / 3) -
                                                                  15) *
                                                              0.45,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 2,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50),
                                      bottomRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.flask,
                                          size: width * 0.13,
                                          color: darkColor,
                                        ),
                                        Text(
                                          "Remaining Fuel [ml]",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.030,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Stack(
                              textDirection: TextDirection.rtl,
                              children: [
                                Container(
                                  width: width,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: darkLighterColor,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Container(
                                            width: width / 2 - 30,
                                            //color: Colors.red,
                                            height: (foureight / 3) - 15,
                                            child: Center(
                                              child: Container(
                                                width: width / 2 - 60,
                                                height: (foureight / 3) - 15,
                                                child: Center(
                                                  child: TextFormField(
                                                    cursorColor: mainColor,
                                                    textAlign: TextAlign.center,
                                                    initialValue: size,
                                                    maxLength: 3,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: "",
                                                      counterStyle: TextStyle(
                                                          fontSize: 0),
                                                    ),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        size = value;
                                                        calculate(
                                                            time, fuel, size);
                                                      });
                                                    },
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      color: Colors.white,
                                                      fontSize:
                                                          ((foureight / 3) -
                                                                  15) *
                                                              0.45,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: width / 2,
                                  height: (foureight / 3) - 15,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(255, 0, 0, 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      bottomLeft: Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        FaIcon(
                                          FontAwesomeIcons.expandArrowsAlt,
                                          color: darkColor,
                                          size: width * 0.13,
                                        ),
                                        Text(
                                          "Fuel Tank Size [ml]",
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w500,
                                            fontSize: width * 0.030,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: twoeight - 15,
                      width: width,
                      child: Row(
                        children: [
                          Container(
                            width: width / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Estimated",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: (twoeight / 2) * 0.2),
                                  ),
                                  Text(
                                    "Runtime",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: (twoeight / 2) * 0.2),
                                  ),
                                  Text(
                                    "[min]",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: (twoeight / 2) * 0.2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            width: width / 2,
                            child: Center(
                              child: Text(
                                result,
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: (twoeight / 2) * 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width,
              height: onefiveHeight - 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: twoeight,
                    width: width / 2 - 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: twoeight / 2,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            color: darkLighterColor,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Strategy(totalFuelMileage: result)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Pit",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.042,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    "Strategy",
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: width * 0.042,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChronoPage()));
                    },
                    child: Container(
                      height: width * 0.2,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: darkLighterColor,
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.stopwatch,
                          color: Colors.white,
                          size: width * 0.07,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: twoeight,
                    width: width / 2 - 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: twoeight / 2,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              bottomLeft: Radius.circular(50),
                            ),
                            color: darkLighterColor,
                          ),
                          child: Center(
                            child: GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (prefs.getString("UID") == "GUEST") {
                                  if (Platform.isIOS) {
                                    showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: new Text("Warning!"),
                                            content: new Text(
                                                "You need to be signed in."),
                                            actions: <Widget>[
                                              CupertinoDialogAction(
                                                textStyle: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                isDefaultAction: true,
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              CupertinoDialogAction(
                                                child: Text("Sign up"),
                                                textStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                onPressed: () async {
                                                  Navigator.pop(context);
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool("login", false);
                                                  prefs.setString("UID", "");
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          RegisterPage(),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                              backgroundColor: darkColor,
                                              elevation: 16,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                              ),
                                              content: Container(
                                                height: safeAreaHeight / 4.5,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text("Warning",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    width *
                                                                        0.07,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white)),
                                                    Text(
                                                        "You need to be signed in.",
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                fontSize:
                                                                    width *
                                                                        0.03,
                                                                color: Colors
                                                                    .white)),
                                                    Container(
                                                      alignment: Alignment
                                                          .bottomCenter,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Cancel",
                                                              style: GoogleFonts
                                                                  .montserrat(
                                                                      color: Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                              onTap: () async {
                                                                Navigator.pop(
                                                                    context);
                                                                SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                prefs.setBool(
                                                                    "login",
                                                                    false);
                                                                prefs.setString(
                                                                    "UID", "");
                                                                Navigator
                                                                    .pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RegisterPage(),
                                                                  ),
                                                                );
                                                              },
                                                              child: Text(
                                                                "Sign up",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                        color: Colors
                                                                            .red),
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ));
                                        });
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SaveSetup(
                                        time,
                                        fuel,
                                        size,
                                        result,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Save",
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: width * 0.042,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculate(String ttime, String ffuel, String ssize) {
    if (ttime.contains(",")) {
      dynamic temp = ttime.split(",");
      ttime = temp[0] + "." + temp[1];
    }
    if (ttime.contains(":")) {
      dynamic temp = ttime.split(":");
      ttime = temp[0] + "." + temp[1];
    }
    try {
      double size = double.parse(ssize);
      double time = double.parse(ttime);
      double fuel = double.parse(ffuel);

      var minutiInSecondi = ((time).floor() * 60);

      var secondi = (time - (time).floor()) * 100;

      var tempoTrascorsoInSecondi = minutiInSecondi + secondi;

      var ccxsec = tempoTrascorsoInSecondi / (size - fuel);

      var calcoloTotale = (size * ccxsec) / 60;

      var calcoloTotaleInMinuti =
          (((calcoloTotale - (calcoloTotale).floor()) * 60) / 100) +
              (calcoloTotale).floor();

      //print(num.parse(calcoloTotaleInMinuti.toStringAsFixed(2)));

      setState(() {
        if (calcoloTotaleInMinuti >= 0) {
          result = num.parse(calcoloTotaleInMinuti.toStringAsFixed(2))
              .toString()
              .replaceAll(".", ":");

          if (result.length == 3) {
            result += "0";
          }
        } else {
          result = "...";
        }
      });
    } on Exception catch (e) {
      // TODO
      print(e);
    }
    //print(String.("%.2f Minutes!", calcoloTotaleInMinuti));
  }
}
