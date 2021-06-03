import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/backend/stints.dart';
import 'package:redsracing/main.dart';
import 'package:redsracing/pages/strategyinfo.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:redsracing/storage_strategies/savedstrategies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class Controller extends GetxController {
  var warningStints = [].obs;
  var strategyList = [].obs;
  addItem(item) {
    warningStints.add(item);
  }

  removeAll() {
    warningStints.removeRange(0, warningStints.length);
  }

  addItemStrat(item) {
    strategyList.add(item);
  }

  removeAllStrat() {
    strategyList.removeRange(0, strategyList.length);
  }
}

class Strategy extends StatefulWidget {
  final String totalFuelMileage;

  const Strategy({Key key, this.totalFuelMileage}) : super(key: key);

  @override
  _StrategyState createState() => _StrategyState();
}

class _StrategyState extends State<Strategy> {
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

  bool showSaveButton = false;

  var uuid = Uuid();

  final _controller = new ScrollController();
  Controller controller;

  double tPieno = 0;
  double tPrimoGiro = 0;
  double tMedio = 0;
  double tGara = 0;
  double tRifornimento = 0;
  double tTotalFuel = 0;
  double margin = 0;
  double oldMinute = 0;

  double tempPieno = 0;
  double tempPrimoGiro = 0;
  double tempMedio = 0;
  double tempGara = 0;
  double tempRifornimento = 0;
  double tempTotalFuel = 0;

  int stintsNumber = 6;
  int raceDuration = 45;
  int giriTotaliGara = 0;

  TextEditingController title = new TextEditingController();
  TextEditingController tec_tPrimoGiro = new TextEditingController();
  TextEditingController tec_tPieno = new TextEditingController();
  TextEditingController tec_tMedio = new TextEditingController();
  TextEditingController tec_tGara = new TextEditingController();
  TextEditingController tec_tTotalFuel = new TextEditingController();

  TextStyle notSelected;
  TextStyle selected;

  final _key = new GlobalKey<FormState>();

  List<dynamic> stintsUnderSafeMargin = [];
  List<dynamic> strategyMap = [];

  bool found = false;
  @override
  void initState() {
    controller = new Controller();
    tec_tTotalFuel.text = widget.totalFuelMileage;
    tTotalFuel = double.parse(tec_tTotalFuel.text.replaceAll(":", "."));
    tGara = raceDuration.toDouble();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeAll();
    controller.removeAllStrat();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.removeAll();
    controller.removeAllStrat();

    final safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

    final fourfiveHeight = (safeAreaHeight / 5) * 4;
    final onefiveHeight = (safeAreaHeight / 5);
    final width = MediaQuery.of(context).size.width;

    final twoeight = (fourfiveHeight / 8) * 2;
    final foureight = (fourfiveHeight / 8) * 4;

    final inputSize = safeAreaHeight * 0.4;

    int count = 0;

    double giroPieno;
    double rifornimentoInSecondi;
    double rifornimentoInMinuti;

    double tempGiri = 0;
    double tempRif = 0;

    var stints = [];

    notSelected = GoogleFonts.montserrat(
      color: Colors.grey[600],
      fontSize: width * 0.05,
    );

    selected = GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: width * 0.07,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Pit Strategy", style: GoogleFonts.montserrat()),
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.infoCircle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StrategyInfo()));
              }),
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SavedStrategies()));
                }
              }),
        ],
      ),
      backgroundColor: darkLighterColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: _controller,
        child: Column(
          children: [
            Container(
              width: width,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: darkColor,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: darkColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Race time [min]",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.045),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: (inputSize / 6) - 10,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              controller.removeAll();
                                              raceDuration = 20;
                                              stintsNumber = 3;
                                              convert();
                                            },
                                          );
                                        },
                                        child: Text("20",
                                            style: raceDuration == 20
                                                ? selected
                                                : notSelected),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              controller.removeAll();
                                              raceDuration = 45;
                                              stintsNumber = 6;
                                              convert();
                                            },
                                          );
                                        },
                                        child: Text("45",
                                            style: raceDuration == 45
                                                ? selected
                                                : notSelected),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              controller.removeAll();
                                              raceDuration = 30;
                                              stintsNumber = 4;
                                              convert();
                                            },
                                          );
                                        },
                                        child: Text("30",
                                            style: raceDuration == 30
                                                ? selected
                                                : notSelected),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(
                                            () {
                                              controller.removeAll();
                                              stintsNumber = 8;
                                              raceDuration = 60;
                                              convert();
                                            },
                                          );
                                        },
                                        child: Text("60",
                                            style: raceDuration == 60
                                                ? selected
                                                : notSelected),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text("Average lap time [sec]",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: width * 0.045)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: darkLighterColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: (inputSize / 6) - 10,
                                  child: TextFormField(
                                    onEditingComplete: () {
                                      if (tec_tMedio.text.contains(",")) {
                                        tec_tMedio.text = tec_tMedio.text
                                            .replaceAll(",", ".");
                                        tec_tPrimoGiro.text = tec_tMedio.text;
                                        tec_tPieno.text = (double.parse(
                                                    tec_tMedio.text
                                                        .replaceAll(",", ".")) +
                                                6)
                                            .toString()
                                            .replaceAll(".0", "");
                                        tMedio = double.parse(tec_tMedio.text);
                                        tPrimoGiro =
                                            double.parse(tec_tPrimoGiro.text);

                                        tPieno = double.parse(tec_tPieno.text);
                                        setState(() {
                                          showSaveButton = true;
                                        });
                                      } else if (tec_tMedio.text
                                          .contains(":")) {
                                        tec_tMedio.text = tec_tMedio.text
                                            .replaceAll(":", ".");
                                        tec_tPrimoGiro.text = tec_tMedio.text;
                                        tec_tPieno.text = (double.parse(
                                                    tec_tMedio.text
                                                        .replaceAll(":", ".")) +
                                                6)
                                            .toString()
                                            .replaceAll(".0", "");
                                        tMedio = double.parse(tec_tMedio.text);
                                        tPrimoGiro =
                                            double.parse(tec_tPrimoGiro.text);

                                        tPieno = double.parse(tec_tPieno.text);
                                        setState(() {
                                          showSaveButton = true;
                                        });
                                      } else {
                                        tec_tPieno.text =
                                            (double.parse(tec_tMedio.text) + 6)
                                                .toString()
                                                .replaceAll(".0", "");
                                        tec_tPrimoGiro.text = tec_tMedio.text;
                                        tMedio = double.parse(tec_tMedio.text);
                                        tPrimoGiro =
                                            double.parse(tec_tPrimoGiro.text);

                                        tPieno = double.parse(tec_tPieno.text);
                                        setState(() {
                                          showSaveButton = true;
                                        });
                                      }
                                      FocusScope.of(context).unfocus();
                                    },
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.043),
                                    controller: tec_tMedio,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: "Average lap time",
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.montserrat(),
                                    ),
                                    cursorColor: mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text("Refuel lap time [sec]",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: width * 0.045)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: darkLighterColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: (inputSize / 6) - 10,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.043),
                                    controller: tec_tPieno,
                                    decoration: InputDecoration(
                                        hintText: "Refuel lap time",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.montserrat()),
                                    cursorColor: mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text("First lap time [sec]",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: width * 0.045)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: darkLighterColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: (inputSize / 6) - 10,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.043),
                                    controller: tec_tPrimoGiro,
                                    decoration: InputDecoration(
                                        hintText: "First lap time",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.montserrat()),
                                    cursorColor: mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Total fuel mileage [min]",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.045),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                      color: darkLighterColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  height: (inputSize / 6) - 10,
                                  child: TextFormField(
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.043),
                                    controller: tec_tTotalFuel,
                                    decoration: InputDecoration(
                                        hintText: "Fuel mileage",
                                        border: InputBorder.none,
                                        hintStyle: GoogleFonts.montserrat()),
                                    cursorColor: mainColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    "Stints you wish to do [n]",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: width * 0.045),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: (inputSize / 6) - 10,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(
                                              () {
                                                controller.removeAll();
                                                stintsNumber =
                                                    (stintsNumber > 0)
                                                        ? (stintsNumber - 1)
                                                        : 0;
                                                convert();
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: width * 0.07,
                                            height: width * 0.07,
                                            decoration: BoxDecoration(
                                              color: darkLighterColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(width * 0.7),
                                              ),
                                            ),
                                            child: Center(
                                              child: FaIcon(
                                                FontAwesomeIcons.minus,
                                                color: Colors.white,
                                                size: width * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          stintsNumber.toString(),
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: width * 0.07),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(
                                              () {
                                                controller.removeAll();
                                                stintsNumber = stintsNumber + 1;
                                                convert();
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: width * 0.07,
                                            height: width * 0.07,
                                            decoration: BoxDecoration(
                                              color: darkLighterColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(width * 0.7),
                                              ),
                                            ),
                                            child: Center(
                                              child: FaIcon(
                                                FontAwesomeIcons.plus,
                                                color: Colors.white,
                                                size: width * 0.04,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.removeAll();
                                    controller.removeAllStrat();

                                    convert();
                                    _controller.animateTo(twoeight + 250,
                                        duration: Duration(seconds: 2),
                                        curve: Curves.fastOutSlowIn);
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Container(
                                    width: width * 0.3,
                                    height: (inputSize / 6) - 10,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Calculate",
                                          style: GoogleFonts.montserrat(
                                              fontSize: 15,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: (width / 4) - 10,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Stint",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.048,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: (width / 4) - 10,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Lap",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.048,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: (width / 4) - 10,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Time",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.048,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "[min]",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: (width / 4) - 10,
                          child: Center(
                            child: Column(
                              children: [
                                Text(
                                  "Safety",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.048,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "[min]",
                                  style: GoogleFonts.montserrat(
                                    fontSize: width * 0.04,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: 6,
                      ),
                      itemCount: (stintsNumber != 0) ? stintsNumber : 0,
                      itemBuilder: (context, index) {
                        if (stintsUnderSafeMargin.length > stintsNumber) {
                          stintsUnderSafeMargin.removeRange(0, stintsNumber);
                        }
                        margin = 0;
                        if (tec_tMedio.text.isNotEmpty &&
                            tec_tPieno.text.isNotEmpty &&
                            tec_tPrimoGiro.text.isNotEmpty &&
                            //tec_tRifornimento.text.isNotEmpty &&
                            tec_tTotalFuel.text.isNotEmpty) {
                          if (count == 0) {
                            tempRifornimento = tPieno - tMedio;

                            giriTotaliGara = ((convertToSeconds(raceDuration) -
                                        (stintsNumber - 1) * tempRifornimento -
                                        tPrimoGiro +
                                        tMedio) /
                                    tMedio)
                                .ceil()
                                .toInt();
                            //print("Giri Totali di gara " +
                            //  giriTotaliGara.toString());

                            tempPieno =
                                convertToSeconds(raceDuration) / stintsNumber;

                            giroPieno =
                                ((tempPieno + tMedio - tPrimoGiro) / tMedio)
                                    .roundToDouble();

                            tempGiri = giroPieno;
                            //print("count " + count.toString());
                            //print("tRifornimento " + tRifornimento.toString());
                            //print("tPrimoGiro " + tPrimoGiro.toString());
                            //print("giroPieno " + giroPieno.toString());
                            rifornimentoInSecondi =
                                ((count)) * tempRifornimento +
                                    tPrimoGiro +
                                    tMedio * (giroPieno.roundToDouble() - 1);
                            margin = 0;
                            margin = convertToSeconds(tTotalFuel) -
                                rifornimentoInSecondi;
                            //print("primoMargine: " + margin.toString());
                            oldMinute = (rifornimentoInSecondi);

                            //print("ns | ng | tstot");
                            //print((index + 1).toString() +
                            //  " | " +
                            // giroPieno.toString() +
                            // " | " +
                            //rifornimentoInSecondi.toString());
                          } else {
                            //giroPieno += tempGiri;

                            (index + 1) != stintsNumber
                                ? giroPieno += tempGiri
                                : giroPieno = giriTotaliGara.toDouble();
                            rifornimentoInSecondi =
                                ((count)) * tempRifornimento +
                                    tPrimoGiro +
                                    tMedio * (giroPieno.roundToDouble() - 1);

                            margin = convertToSeconds(tTotalFuel) -
                                ((rifornimentoInSecondi) - oldMinute);

                            oldMinute = (rifornimentoInSecondi);

                            //stints.add();
                          }

                          count += 1;

                          if ((margin < 15)) {
                            stintsUnderSafeMargin.add({
                              "stintNumber": index + 1,
                              "marginLeft": margin
                            });
                            controller.addItem((index + 1));
                          }
                          controller.addItemStrat({
                            "stint": index + 1,
                            "lap": giroPieno
                                .roundToDouble()
                                .toString()
                                .replaceAll(".0", ""),
                            "time": convertToMinutes(rifornimentoInSecondi)
                                .toStringAsFixed(2)
                                .replaceAll(".", ":"),
                            "margin": (margin < tMedio * 0.5)
                                ? convertToMinutes(margin)
                                        .toStringAsFixed(2)
                                        .replaceAll(".", ":") +
                                    "*"
                                : convertToMinutes(margin)
                                    .toStringAsFixed(2)
                                    .replaceAll(".", ":"),
                          });

                          if (true) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: (width / 4) - 10,
                                  child: Center(
                                    child: Text(
                                      (index + 1).toString(),
                                      style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: (width / 4) - 10,
                                  child: Center(
                                    child: Text(
                                      giroPieno
                                          .roundToDouble()
                                          .toString()
                                          .replaceAll(".0", ""),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: (width / 4) - 10,
                                  child: Center(
                                    child: Text(
                                      convertToMinutes(rifornimentoInSecondi)
                                          .toStringAsFixed(2)
                                          .replaceAll(".", ":"),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: (width / 4) - 10,
                                  child: Center(
                                    child: Text(
                                      (margin < tMedio * 0.5)
                                          ? convertToMinutes(margin)
                                                  .toStringAsFixed(2)
                                                  .replaceAll(".", ":") +
                                              "*"
                                          : convertToMinutes(margin)
                                              .toStringAsFixed(2)
                                              .replaceAll(".", ":"),
                                      style: GoogleFonts.montserrat(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  ),
                  /*
                  Center(
                      child: Column(
                    children: [
                      Text(
                        "WARNING! You will not end the race at stints: \n",
                        style: GoogleFonts.montserrat(
                          fontSize: width * 0.04,
                          color: mainColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        showStints(),
                        style: GoogleFonts.montserrat(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            color: mainColor),
                      ),
                      SizedBox(height: 20),
                    ],
                  )),*/
                  showSaveButton
                      ? Column(
                          children: [
                            Center(
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
                                                    prefs.setBool(
                                                        "login", false);
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
                                                                onTap:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  SharedPreferences
                                                                      prefs =
                                                                      await SharedPreferences
                                                                          .getInstance();
                                                                  prefs.setBool(
                                                                      "login",
                                                                      false);
                                                                  prefs
                                                                      .setString(
                                                                          "UID",
                                                                          "");
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
                                                                          color:
                                                                              Colors.red),
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
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: darkColor,
                                          insetPadding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          elevation: 16,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            width: width,
                                            height: safeAreaHeight / 4,
                                            child: Center(
                                              child: Form(
                                                key: _key,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: TextFormField(
                                                        controller: title,
                                                        style: GoogleFonts
                                                            .montserrat(),
                                                        decoration: InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText: "Title",
                                                            hintStyle: GoogleFonts
                                                                .montserrat()),
                                                        validator: (value) {
                                                          if (value.isEmpty) {
                                                            return "Please enter a title";
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () async {
                                                            if (_key
                                                                .currentState
                                                                .validate()) {
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          'yyyy-MM-dd - hh:mm:ss')
                                                                      .format(DateTime
                                                                          .now());
                                                              try {
                                                                Map<String,
                                                                        dynamic>
                                                                    data = {
                                                                  "title": title
                                                                      .text,
                                                                  "strategy":
                                                                      controller
                                                                          .strategyList,
                                                                  "uid":
                                                                      uuid.v1(),
                                                                  "dateTime":
                                                                      formattedDate
                                                                };

                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "utenti")
                                                                    .doc(Constants
                                                                        .myUID)
                                                                    .collection(
                                                                        "strategies")
                                                                    .add(data)
                                                                    .whenComplete(
                                                                        () {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                    msg:
                                                                        "Session saved",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .SNACKBAR,
                                                                    timeInSecForIosWeb:
                                                                        1,
                                                                    backgroundColor:
                                                                        darkLighterColor,
                                                                  );
                                                                  controller
                                                                      .removeAll();
                                                                  controller
                                                                      .removeAllStrat();
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              } catch (FirebaseException) {
                                                                print(
                                                                    FirebaseException);
                                                              }
                                                            }
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: mainColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      top: 20,
                                                                      bottom:
                                                                          20),
                                                              child: Text(
                                                                  "Save Session",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                          color:
                                                                              Colors.white)),
                                                            ),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: mainColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    20),
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right: 20,
                                                                      top: 20,
                                                                      bottom:
                                                                          20),
                                                              child: Text(
                                                                  "Discard",
                                                                  style: GoogleFonts
                                                                      .montserrat(
                                                                          color:
                                                                              Colors.white)),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  width: width * 0.3,
                                  height: (inputSize / 6) - 10,
                                  decoration: BoxDecoration(
                                    color: darkColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Save",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 100,
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String showStints() {
    String temp = "";
    //print(stintsUnderSafeMargin[1]["marginLeft"]);
    /*
    for (int i = 0; i < controller.warningStints.length; i++) {
      if (i != (controller.warningStints.length - 1)) {
        temp += controller.warningStints[i].toString() + ", ";
      } else {
        temp += controller.warningStints[i].toString();
      }
    }
*/
    for (var item in stintsUnderSafeMargin) {
      print(convertToMinutes(item["marginLeft"]));
      temp += item["stintNumber"].toString();
    }
    return temp;
  }

  GlobalKey key = new GlobalKey();

  void getStrategy() {
    tPrimoGiro = double.parse(tec_tPrimoGiro.text);
    tPieno = double.parse(tec_tPieno.text);
    tMedio = double.parse(tec_tMedio.text);
    tGara = double.parse(tec_tGara.text);
    //tRifornimento = double.parse(tec_tRifornimento.text);
    //print(tPieno.toString());
    //print(tMedio.toString());
    //print(tGara.toString());
    //print(tRifornimento.toString());

    tRifornimento = convertToSeconds(
        tRifornimento); //converto il tempo di rifornimento da minuti a secondi

    double giroPieno = (tRifornimento / tMedio)
        .roundToDouble(); //trovo ogni quanti giri circa devo fermarmi

    double rifornimentoInSecondi = (giroPieno * tMedio) -
        (tMedio) +
        tPrimoGiro; //trovo a quanti minuti dovrò fermarmi in secondi

    double rifornimentoInMinuti = convertToMinutes(
        rifornimentoInSecondi); //trovo a quale minuto devo fermarmi

    print("--------");
    print("1 - Giro: " +
        giroPieno.toString() +
        " | Minuto: " +
        rifornimentoInMinuti.toString());

    int pieniTotali = (tGara * 60 / tRifornimento).floor();
    double nextGiri = giroPieno;
    double nextRifornimento = convertToSeconds(rifornimentoInMinuti);

    for (var i = 0; i < pieniTotali - 1; i++) {
      nextGiri += giroPieno;
      nextRifornimento += rifornimentoInSecondi + (tPieno - tMedio);
      if (convertToMinutes(nextRifornimento) > tGara) {
        print("Attenzione, arriverai a fine gara con un margine di: " +
            convertToMinutes(((nextRifornimento) - convertToSeconds(tGara)))
                .toString() +
            " minuti");
      } else {
        print("--------");
        print((i + 2).toString() +
            " - Giro: " +
            nextGiri.toString() +
            " | Minuto: " +
            convertToMinutes(nextRifornimento).toString());
      }
    }
  }

  double convertToSeconds(time) {
    int minutiInSecondi = (((time).floor() * 60)).round();

    int secondi = ((time - (time).floor()) * 100).round();
    int tempint = (minutiInSecondi + secondi);
    String temp = tempint.toString();
    time = double.parse(temp);

    return time;
  }

  double convertToMinutes(time) {
    double rifornimentoInMinuti = ((time / 60).floorToDouble());
    double tempp = (time - (rifornimentoInMinuti * 60)) / 100;
    rifornimentoInMinuti += tempp;

    return rifornimentoInMinuti;
  }

  void convert() {
    if ((tec_tPrimoGiro.text.isNotEmpty) &&
        (tec_tPieno.text.isNotEmpty) &&
        (tec_tMedio.text.isNotEmpty))
      setState(() {
        found = false;
        showSaveButton = true;
        if (tec_tPrimoGiro.text.contains(",")) {
          tPrimoGiro = double.parse(tec_tPrimoGiro.text.replaceAll(",", "."));
        } else if (tec_tPrimoGiro.text.contains(":")) {
          tPrimoGiro = double.parse(tec_tPrimoGiro.text.replaceAll(":", "."));
        } else {
          tPrimoGiro = double.parse(tec_tPrimoGiro.text);
        }

        if (tec_tPieno.text.contains(",")) {
          tPieno = double.parse(tec_tPieno.text.replaceAll(",", "."));
        } else if (tec_tPieno.text.contains(":")) {
          tPieno = double.parse(tec_tPieno.text.replaceAll(":", "."));
        } else {
          tPieno = double.parse(tec_tPieno.text);
        }

        if (tec_tMedio.text.contains(",")) {
          tMedio = double.parse(tec_tMedio.text.replaceAll(",", "."));
        } else if (tec_tMedio.text.contains(":")) {
          tMedio = double.parse(tec_tMedio.text.replaceAll(":", "."));
        } else {
          tMedio = double.parse(tec_tMedio.text);
        }

        if (tec_tTotalFuel.text.contains(",")) {
          tTotalFuel = double.parse(tec_tTotalFuel.text.replaceAll(",", "."));
        } else if (tec_tTotalFuel.text.contains(":")) {
          tTotalFuel = double.parse(tec_tTotalFuel.text.replaceAll(":", "."));
        } else {
          tTotalFuel = double.parse(tec_tTotalFuel.text);
        }
      });
  }
}
