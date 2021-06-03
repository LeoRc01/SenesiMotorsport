import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_sessions/savedsessions.dart';
import 'package:redsracing/storage_setups/savedsetups.dart';

class ShowSession extends StatefulWidget {
  final List<dynamic> laps;
  final String fastestLap;
  final String slowestLap;
  final String averageLap;
  final String title;
  final String totalDuration;
  final String uid;

  const ShowSession(
      {this.laps,
      this.fastestLap,
      this.slowestLap,
      this.averageLap,
      this.title,
      this.totalDuration,
      this.uid});

  @override
  _ShowSessionState createState() => _ShowSessionState();
}

class _ShowSessionState extends State<ShowSession> {
  var _key = new GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Color darkColor = Color.fromRGBO(30, 30, 30, 1);
    Color mainColor = Color.fromRGBO(255, 0, 0, 1);
    Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

    final width = MediaQuery.of(context).size.width;
    final safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;

    TextStyle timeStyle = GoogleFonts.bebasNeue(
        color: darkColor, fontSize: width * 0.18, fontWeight: FontWeight.bold);
    TextStyle lapStyle = GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: width * 0.05,
        fontWeight: FontWeight.bold);
    TextStyle bottonStyle = GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: width * 0.04,
        fontWeight: FontWeight.bold);
    TextStyle endSessionStyle = GoogleFonts.montserrat(
        color: Colors.white,
        fontSize: width * 0.07,
        fontWeight: FontWeight.bold);

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        title: Text("Save Your Run", style: GoogleFonts.montserrat()),
      ),
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
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
                            "Total Duration",
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
                            widget.totalDuration,
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
                            "Fastest Lap",
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
                            widget.fastestLap,
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
                            "Slowest Lap",
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
                            widget.slowestLap,
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
                            "Average Lap",
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
                            widget.averageLap,
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
              SizedBox(
                height: height * 0.06,
              ),
              Container(
                height: 200,
                width: width,
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.laps.length,
                      itemBuilder: (builder, index) {
                        //return Text("Lap " +
                        //  (index + 1).toString() +
                        // " " +
                        // (widget.laps[index]).toString());
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Lap " + (index + 1).toString(),
                                    style: lapStyle),
                                Text(
                                  widget.laps[index]['lapTime'].toString(),
                                  style: lapStyle,
                                ),
                              ],
                            ),
                            Divider(height: 10, color: Colors.grey),
                          ],
                        );
                      }),
                ),
              ),
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
        .collection("sessions")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      print(snapshot.docs.toString());
      snapshot.docs.first.reference.delete().whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SavedSessions()));
      });
    }).catchError((FirebaseException) => print(FirebaseException));
  }
}
