import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_setups/savedsetups.dart';

class ShowSetup extends StatefulWidget {
  final String time;
  final String fuel;
  final String size;
  final String runTime;
  final String title;
  final String notes;
  final String uid;
  final String track;
  final String date;
  final engine;

  ShowSetup(this.time, this.fuel, this.size, this.runTime, this.title,
      this.notes, this.uid, this.track, this.date, this.engine);

  @override
  _ShowSetupState createState() => _ShowSetupState();
}

class _ShowSetupState extends State<ShowSetup> {
  var _key = new GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Color darkColor = Color.fromRGBO(30, 30, 30, 1);
    Color mainColor = Color.fromRGBO(255, 0, 0, 1);
    Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                widget.title,
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: width * 0.1,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              widget.notes.length != 0
                  ? Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          width: width,
                          color: darkLighterColor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.notes,
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.045)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )
                  : Container(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Track",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.track,
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Date",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.date,
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Estimated run time",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.runTime + " min",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Elapsed time",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.time.replaceAll(".", ":") + " min",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Remaining fuel",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.fuel + " ml",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: width,
                color: darkLighterColor,
                child: Row(
                  children: [
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Fuel tank size",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.045),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: width / 2 - 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.size + " ml",
                            style: GoogleFonts.montserrat(
                                color: Colors.white, fontSize: width * 0.05),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: .5,
                height: 0,
              ),
              widget.engine != null
                  ? Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      width: width,
                      color: darkLighterColor,
                      child: Row(
                        children: [
                          Container(
                            width: width / 2 - 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Engine",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.045),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width / 2 - 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onLongPress: () {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            decoration: BoxDecoration(
                                                color: darkColor,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Engine info",
                                                  style: GoogleFonts.montserrat(
                                                      color: mainColor,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.05,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  widget.engine['engine'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Manifold: " +
                                                      widget.engine['manifold'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Pipe: " +
                                                      widget.engine['pipe'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  widget.engine['pinione']
                                                          .toString()
                                                          .substring(0, 2) +
                                                      "/" +
                                                      widget.engine['corona']
                                                          .toString()
                                                          .substring(0, 2),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Venturi: " +
                                                      widget.engine['venturi'],
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Liters: " +
                                                      widget.engine['liters']
                                                          .toString(),
                                                  style: GoogleFonts.montserrat(
                                                      color: Colors.white),
                                                ),
                                                Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 15),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      decoration: BoxDecoration(
                                                        color: mainColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(10),
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Back",
                                                          style: GoogleFonts
                                                              .montserrat(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    widget.engine['engine'].toString() == "null"
                                        ? "No engine selected."
                                        : widget.engine['engine'].toString(),
                                    style: widget.engine['engine'].toString() ==
                                            "null"
                                        ? GoogleFonts.montserrat(
                                            color: mainColor,
                                            fontSize: width * 0.04)
                                        : GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: width * 0.05),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              SizedBox(
                height: height * 0.05,
              ),
              GestureDetector(
                onTap: () {
                  deleteSetup();
                },
                child: Container(
                  width: width * 0.3,
                  height: height * 0.056,
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Container(
                    child: Center(
                      child: Text(
                        "Delete",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  deleteSetup() async {
    print(widget.uid);
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("setups")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      snapshot.docs.first.reference.delete().whenComplete(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SavedSetups()));
      });
    });
  }

  savedata() async {
    if (_key.currentState.validate()) {
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "notes": notesController.text.trim(),
        "estimated_run_time": widget.runTime,
        "elapsed_time": widget.time,
        "remaining_fuel": widget.fuel,
        "fuel_tank_size": widget.size,
      };
      await FirebaseFirestore.instance
          .collection("utenti")
          .doc(Constants.myUID)
          .collection("setups")
          .add(data)
          .then(
        (value) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        },
      );
    }
  }
}
