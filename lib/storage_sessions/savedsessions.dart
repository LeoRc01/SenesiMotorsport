import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/chronoPage.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_sessions/showsession.dart';
import 'package:uuid/uuid.dart';

class SavedSessions extends StatefulWidget {
  @override
  SavedSessionsState createState() => SavedSessionsState();
}

class SavedSessionsState extends State<SavedSessions> {
  var _key = new GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();

  QuerySnapshot setupsQuerySnapshot;

  @override
  void initState() {
    getSetups();
    super.initState();
  }

  bool isLoading = true;

  Widget setups() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: setupsQuerySnapshot.docs.length,
      itemBuilder: (context, index) {
        return SetupTile(
          laps: setupsQuerySnapshot.docs[index].data()["laps"],
          fastestLap:
              setupsQuerySnapshot.docs[index].data()["fastestLap"].toString(),
          slowestLap:
              setupsQuerySnapshot.docs[index].data()["slowestLap"].toString(),
          averageLap:
              setupsQuerySnapshot.docs[index].data()["averageLap"].toString(),
          title: setupsQuerySnapshot.docs[index].data()["title"].toString(),
          totalDuration: setupsQuerySnapshot.docs[index]
              .data()["totalDuration"]
              .toString(),
          uid: setupsQuerySnapshot.docs[index].data()["uid"].toString(),
        );
      },
    );
  }

  getSetups() async {
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("sessions")
        .orderBy("dateTime", descending: true)
        .get()
        .then((value) {
      setState(() {
        setupsQuerySnapshot = value;
        isLoading = false;
        print("foundsetup");
      });
    }).catchError((onError) => print(onError));
  }

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
        title: Text(
          "Sessions",
          style: GoogleFonts.montserrat(),
        ),
        leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.white,
            ),
            highlightColor: mainColor,
            splashColor: mainColor,
            onPressed: () => Navigator.pop(context)
            //Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage())),
            ),
      ),
      backgroundColor: darkColor,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    setupsQuerySnapshot.docs.length == 0
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "No runs found",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: width * 0.06),
                              )
                            ],
                          ))
                        : setups(),
                  ],
                ),
              ),
            ),
    );
  }
}

class SetupTile extends StatelessWidget {
  final List<dynamic> laps;
  final String fastestLap;
  final String slowestLap;
  final String averageLap;
  final String title;
  final String totalDuration;
  final String uid;

  const SetupTile(
      {this.laps,
      this.fastestLap,
      this.slowestLap,
      this.averageLap,
      this.title,
      this.totalDuration,
      this.uid});

  @override
  Widget build(BuildContext context) {
    Color darkColor = Color.fromRGBO(30, 30, 30, 1);
    Color mainColor = Color.fromRGBO(255, 0, 0, 1);
    Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ShowSession(
                  laps: laps,
                  fastestLap: fastestLap,
                  slowestLap: slowestLap,
                  averageLap: averageLap,
                  title: title,
                  totalDuration: totalDuration,
                  uid: uid,
                ),
              ),
            );
          },
          child: Container(
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
                        title,
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
                        fastestLap,
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: width * 0.05),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey,
          thickness: .5,
          height: 0,
        ),
      ],
    );
  }
}
