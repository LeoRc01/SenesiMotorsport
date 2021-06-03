import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:redsracing/storage_sessions/savedsessions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:screen/screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';

class ChronoPage extends StatefulWidget {
  @override
  _ChronoPageState createState() => _ChronoPageState();
}

class _ChronoPageState extends State<ChronoPage> {
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

  List<dynamic> laptimes = [];

  double currentFastestLap = 0;
  double currentFastestLapIndex = 0;

  var uuid = Uuid();

  final _key = new GlobalKey<FormState>();

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: false,
  );

  final StopWatchTimer _stopWatchLapTimer = StopWatchTimer(
    isLapHours: true,
  );

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// Can be set preset time. This case is "00:01.23".
    // _stopWatchTimer.setPresetTime(mSec: 1234);
  }

  bool isStopped = true;
  bool isLoading = false;
  bool firstOpen = true;

  String title = "";

  @override
  void dispose() async {
    super.dispose();
    currentFastestLap = 0;
    currentFastestLapIndex = 0;
    await _stopWatchTimer.dispose();
    await _stopWatchLapTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Screen.keepOn(true);

    final width = MediaQuery.of(context).size.width;
    final safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

    TextStyle timeStyle = GoogleFonts.bebasNeue(
        color: darkColor, fontSize: width * 0.18, fontWeight: FontWeight.bold);
    TextStyle lapStyle = GoogleFonts.montserrat(
        color: darkColor, fontSize: width * 0.05, fontWeight: FontWeight.bold);
    TextStyle bottonStyle = GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: width * 0.04,
        fontWeight: FontWeight.bold);
    TextStyle endSessionStyle = GoogleFonts.montserrat(
      color: Colors.white,
      fontSize: width * 0.07,
    );

    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: mainColor,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  ////TOP PART
                  Container(
                    height: safeAreaHeight / 4,
                    width: width,
                    decoration: BoxDecoration(
                      color: darkColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: width / 2,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: FaIcon(
                                    FontAwesomeIcons.chevronLeft,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: width / 2,
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).padding.top),
                                child: IconButton(
                                  onPressed: () async {
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
                                                      prefs.setString(
                                                          "UID", "");
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
                                                        BorderRadius.circular(
                                                            40),
                                                  ),
                                                  content: Container(
                                                    height:
                                                        safeAreaHeight / 4.5,
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
                                                                          color:
                                                                              Colors.blue),
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
                                                                    prefs.setString(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SavedSessions()));
                                    }
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.save,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: (safeAreaHeight / 4) / 2,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset(
                            "assets/redslogo.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //////CHRONO PART
                  GestureDetector(
                    onTap: () async {
                      if (_stopWatchTimer.rawTime.value > 0 && !isStopped) {
                        _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
                        setState(() {
                          //GET LAP TIME
                          String lap = correctTime(
                              _stopWatchTimer.rawTime.value.toString());
                        });
                      }
                    },
                    child: Container(
                      height: (safeAreaHeight / 4) * 2,
                      width: width,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: (safeAreaHeight / 2) / 3.3,
                            width: width,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  //PRIMO TIMER GRANDE
                                  StreamBuilder<int>(
                                    stream: _stopWatchLapTimer.rawTime,
                                    initialData:
                                        _stopWatchLapTimer.rawTime.value,
                                    builder: (context, snap) {
                                      final value = snap.data;
                                      final displayTime =
                                          StopWatchTimer.getDisplayTime(value,
                                              hours: false);
                                      return Text(
                                        displayTime,
                                        style: GoogleFonts.bebasNeue(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ((safeAreaHeight / 2) / 4) *
                                                    0.6),
                                      );
                                    },
                                  ),
                                  //SECONDO TIMER PICCOLO
                                  StreamBuilder<int>(
                                    stream: _stopWatchTimer.rawTime,
                                    initialData: _stopWatchTimer.rawTime.value,
                                    builder: (context, snap) {
                                      final value = snap.data;
                                      final displayTime =
                                          StopWatchTimer.getDisplayTime(value,
                                              hours: false);
                                      return Text(
                                        displayTime,
                                        style: GoogleFonts.bebasNeue(
                                            color: darkColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                ((safeAreaHeight / 2) / 4) *
                                                    0.18),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 0,
                            width: 0,
                            child: Center(
                              child: StreamBuilder(
                                stream: _stopWatchTimer.records,
                                initialData: _stopWatchTimer.records.value,
                                builder: (context, snap) {
                                  final value = snap.data;

                                  if (value.isEmpty) {
                                    return Container();
                                  }
                                  //RESETTO E STARTO IL TIMER PICCOLO
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.reset);
                                      _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.start);

                                      return Container();
                                    },
                                    itemCount: value.length,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            height: ((safeAreaHeight / 2) / 4) * 2.7,
                            width: width,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: BouncingScrollPhysics(),
                              itemCount: laptimes.length,
                              itemBuilder: (context, index) {
                                return Center(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: (width / 8) * 2,
                                        color: Colors.blue,
                                      ),
                                      //HERE GOES THE LAPS
                                      Container(
                                        width: (width / 8) * 4,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                    "Lap " +
                                                        laptimes[index]
                                                                ["lapNumber"]
                                                            .toInt()
                                                            .toString(),
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: width * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                                Text(
                                                  laptimes[index]["lapTime"]
                                                      .toStringAsFixed(3),
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: width * 0.05,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Divider(
                                              height: 1,
                                              color: darkColor,
                                            )
                                          ],
                                        ),
                                      ),

                                      ///HERE GOES THE "BEST"
                                      Container(
                                        width: (width / 8) * 2,
                                        child: Center(
                                            child: currentFastestLapIndex ==
                                                    index
                                                ? Text(
                                                    "BEST",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                      fontSize: width * 0.05,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Container()),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///START RESET STOP ROW
                  Container(
                    height: (safeAreaHeight / 4) +
                        MediaQuery.of(context).padding.bottom,
                    width: width,
                    decoration: BoxDecoration(
                      color: darkColor,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              /////START THE TIMER
                              GestureDetector(
                                onTap: () async {
                                  _stopWatchTimer.onExecute
                                      .add(StopWatchExecute.start);
                                  _stopWatchLapTimer.onExecute
                                      .add(StopWatchExecute.start);
                                  setState(() {
                                    isStopped = false;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isStopped
                                        ? mainColor
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 20),
                                    child: Text("Start", style: bottonStyle),
                                  ),
                                ),
                              ),
                              //////////////////////////////////////
                              ///RESET TIMER
                              GestureDetector(
                                onTap: () async {
                                  if (isStopped) {
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.reset);
                                    _stopWatchLapTimer.onExecute
                                        .add(StopWatchExecute.reset);

                                    laptimes.removeRange(0, laptimes.length);
                                    currentFastestLap = 0;
                                    currentFastestLapIndex = 0;
                                    setState(() {
                                      isStopped = true;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isStopped
                                        ? mainColor
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 20),
                                    child: Text("Reset", style: bottonStyle),
                                  ),
                                ),
                              ),
                              //////////////////////////////////////
                              /////STOP THE TIMER
                              GestureDetector(
                                onTap: () async {
                                  if (isStopped == false) {
                                    _stopWatchTimer.onExecute
                                        .add(StopWatchExecute.stop);
                                    _stopWatchLapTimer.onExecute
                                        .add(StopWatchExecute.stop);
                                    setState(() {
                                      isStopped = true;
                                    });
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !isStopped
                                        ? mainColor
                                        : Colors.grey[800],
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: 20),
                                    child: Text("Stop", style: bottonStyle),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                if (isStopped) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        insetPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        elevation: 16,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: darkColor,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: width,
                                          height: safeAreaHeight / 2,
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
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextFormField(
                                                      onChanged: (value) {
                                                        setState(() {
                                                          title = value;
                                                        });
                                                      },
                                                      style: GoogleFonts
                                                          .montserrat(),
                                                      decoration: InputDecoration(
                                                          border:
                                                              InputBorder.none,
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
                                                  Text(
                                                    "Fastest lap: " +
                                                        findFastestLap(
                                                            laptimes),
                                                    style: endSessionStyle,
                                                  ),
                                                  Text(
                                                    "Slowest lap: " +
                                                        findSlowestLap(
                                                            laptimes),
                                                    style: endSessionStyle,
                                                  ),
                                                  Text(
                                                    "Average lap: " +
                                                        getAverageLap(laptimes),
                                                    style: endSessionStyle,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                          if (prefs.getString(
                                                                  "UID") ==
                                                              "GUEST") {
                                                            if (Platform
                                                                .isIOS) {
                                                              showCupertinoDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return CupertinoAlertDialog(
                                                                      title: new Text(
                                                                          "Warning!"),
                                                                      content:
                                                                          new Text(
                                                                              "You need to be signed in."),
                                                                      actions: <
                                                                          Widget>[
                                                                        CupertinoDialogAction(
                                                                          textStyle: TextStyle(
                                                                              color: Colors.blue,
                                                                              fontWeight: FontWeight.bold),
                                                                          isDefaultAction:
                                                                              true,
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text("Cancel"),
                                                                        ),
                                                                        CupertinoDialogAction(
                                                                          child:
                                                                              Text("Sign up"),
                                                                          textStyle: TextStyle(
                                                                              color: Colors.red,
                                                                              fontWeight: FontWeight.bold),
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.pop(context);
                                                                            SharedPreferences
                                                                                prefs =
                                                                                await SharedPreferences.getInstance();
                                                                            prefs.setBool("login",
                                                                                false);
                                                                            prefs.setString("UID",
                                                                                "");
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
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                        backgroundColor:
                                                                            darkColor,
                                                                        elevation:
                                                                            16,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(40),
                                                                        ),
                                                                        content:
                                                                            Container(
                                                                          height:
                                                                              safeAreaHeight / 4.5,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              Text("Warning", style: GoogleFonts.montserrat(fontSize: width * 0.07, fontWeight: FontWeight.bold, color: Colors.white)),
                                                                              Text("You need to be signed in.", style: GoogleFonts.montserrat(fontSize: width * 0.03, color: Colors.white)),
                                                                              Container(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Text(
                                                                                        "Cancel",
                                                                                        style: GoogleFonts.montserrat(color: Colors.blue),
                                                                                      ),
                                                                                    ),
                                                                                    GestureDetector(
                                                                                        onTap: () async {
                                                                                          Navigator.pop(context);
                                                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                          prefs.setBool("login", false);
                                                                                          prefs.setString("UID", "");
                                                                                          Navigator.pushReplacement(
                                                                                            context,
                                                                                            MaterialPageRoute(
                                                                                              builder: (context) => RegisterPage(),
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Text(
                                                                                          "Sign up",
                                                                                          style: GoogleFonts.montserrat(color: Colors.red),
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
                                                            if (_key
                                                                .currentState
                                                                .validate()) {
                                                              Navigator.pop(
                                                                  context);
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                              String
                                                                  formattedDate =
                                                                  DateFormat(
                                                                          "yy-mm-dd - hh:mm:ss")
                                                                      .format(DateTime
                                                                          .now());
                                                              Map<String,
                                                                      dynamic>
                                                                  data = {
                                                                "totalDuration":
                                                                    StopWatchTimer
                                                                        .getDisplayTime(
                                                                  _stopWatchLapTimer
                                                                      .rawTime
                                                                      .value,
                                                                ),
                                                                "title": title,
                                                                "fastestLap":
                                                                    findFastestLap(
                                                                        laptimes),
                                                                "slowestLap":
                                                                    findSlowestLap(
                                                                        laptimes),
                                                                "averageLap":
                                                                    getAverageLap(
                                                                        laptimes),
                                                                "laps":
                                                                    laptimes,
                                                                "uid":
                                                                    uuid.v1(),
                                                                "dateTime":
                                                                    formattedDate,
                                                              };
                                                              try {
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        "utenti")
                                                                    .doc(Constants
                                                                        .myUID)
                                                                    .collection(
                                                                        "sessions")
                                                                    .add(data)
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    isLoading =
                                                                        false;

                                                                    laptimes.removeRange(
                                                                        0,
                                                                        laptimes
                                                                            .length);
                                                                    currentFastestLap =
                                                                        0;
                                                                    currentFastestLapIndex =
                                                                        0;
                                                                    _stopWatchTimer
                                                                        .onExecute
                                                                        .add(StopWatchExecute
                                                                            .reset);
                                                                    _stopWatchLapTimer
                                                                        .onExecute
                                                                        .add(StopWatchExecute
                                                                            .reset);
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
                                                                  });
                                                                });
                                                              } catch (FirebaseException) {
                                                                setState(() {
                                                                  isLoading =
                                                                      false;
                                                                });
                                                                print(
                                                                    FirebaseException);
                                                                /*
                                                            Fluttertoast
                                                                .showToast(
                                                              msg:
                                                                  "Something went wrong. Check your internet connection.",
                                                              toastLength: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  ToastGravity
                                                                      .SNACKBAR,
                                                              timeInSecForIosWeb:
                                                                  1,
                                                              backgroundColor:
                                                                  darkLighterColor,
                                                            );*/
                                                              }
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    top: 20,
                                                                    bottom: 20),
                                                            child: Text(
                                                                "Save Session",
                                                                style:
                                                                    bottonStyle),
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () async {
                                                          Navigator.pop(
                                                              context);
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    right: 20,
                                                                    top: 20,
                                                                    bottom: 20),
                                                            child: Text(
                                                                "Discard",
                                                                style:
                                                                    bottonStyle),
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
                                decoration: BoxDecoration(
                                  color: (isStopped)
                                      ? mainColor
                                      : Colors.grey[800],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 20, bottom: 20),
                                  child:
                                      Text("End Session", style: bottonStyle),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  String correctTime(String rawtime) {
    double timeInSeconds = double.parse(rawtime) / 1000;
    Map<String, double> data = {
      "lapNumber": (laptimes.length + 1).toDouble(),
      "lapTime": timeInSeconds
    };
    laptimes.insert(0, data);

    if (laptimes.length > 1) {
      if (currentFastestLap == 0) {
        currentFastestLap = timeInSeconds;
      } else {
        if (timeInSeconds < currentFastestLap) {
          currentFastestLap = timeInSeconds;
          currentFastestLapIndex = 0;
        } else {
          currentFastestLapIndex++;
        }
      }
    }

    if (timeInSeconds >= 60) {
      return StopWatchTimer.getDisplayTime(int.parse(rawtime), hours: false);
    } else {
      return timeInSeconds.toStringAsFixed(3);
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

  String findSlowestLap(List<dynamic> laps) {
    if (laps.length > 0) {
      double fastestLap = laps[0]["lapTime"];
      for (var i = 1; i < laps.length - 1; i++) {
        if (laps[i]["lapTime"] > fastestLap) {
          fastestLap = laps[i]["lapTime"];
        }
      }
      if (fastestLap >= 60) {
        return StopWatchTimer.getDisplayTime(fastestLap.toInt(), hours: false);
      } else {
        return fastestLap.toStringAsFixed(3);
      }
    } else {
      return 0.toString();
    }
  }

  String getAverageLap(List<dynamic> laps) {
    if (laps.length > 0) {
      double somma = 0;
      int count = 0;
      double result = 0;
      for (var i = 0; i < laps.length - 1; i++) {
        somma += laps[i]["lapTime"];
        count++;
      }
      result = somma / count;
      if (result >= 60) {
        return StopWatchTimer.getDisplayTime(result.toInt(), hours: false);
      } else {
        return result.toStringAsFixed(3);
      }
    } else {
      return 0.toString();
    }
  }

  String findFastestLap(List<dynamic> laps) {
    if (laps.length > 0) {
      double fastestLap = laps[0]["lapTime"];

      for (var i = 1; i < laps.length - 1; i++) {
        if (laps[i]["lapTime"] < fastestLap) {
          fastestLap = laps[i]["lapTime"];
        }
      }
      if (fastestLap >= 60) {
        return StopWatchTimer.getDisplayTime(fastestLap.toInt(), hours: false);
      } else {
        return fastestLap.toStringAsFixed(3);
      }
    } else {
      return 0.toString();
    }
  }
}
