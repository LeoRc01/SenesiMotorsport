import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_setups/showsetup.dart';
import 'package:uuid/uuid.dart';

class SavedSetups extends StatefulWidget {
  @override
  _SavedSetupsState createState() => _SavedSetupsState();
}

class _SavedSetupsState extends State<SavedSetups> {
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
          setupsQuerySnapshot.docs[index]
              .data()["elapsed_time"]
              .toString()
              .replaceAll(".", ":"),
          setupsQuerySnapshot.docs[index].data()["remaining_fuel"].toString(),
          setupsQuerySnapshot.docs[index].data()["fuel_tank_size"].toString(),
          setupsQuerySnapshot.docs[index]
              .data()["estimated_run_time"]
              .toString(),
          setupsQuerySnapshot.docs[index].data()["title"].toString(),
          setupsQuerySnapshot.docs[index].data()["notes"].toString(),
          setupsQuerySnapshot.docs[index].data()["uid"].toString(),
          setupsQuerySnapshot.docs[index].data()["track"].toString(),
          setupsQuerySnapshot.docs[index].data()["date"].toString(),
          setupsQuerySnapshot.docs[index].data()["engine"],
        );
      },
    );
  }

  getSetups() async {
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("setups")
        .get()
        .then((value) {
      setState(() {
        setupsQuerySnapshot = value;
        isLoading = false;
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
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
          highlightColor: mainColor,
          splashColor: mainColor,
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainPage())),
        ),
        title: Text("Car runs", style: GoogleFonts.montserrat()),
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
  final String time;
  final String fuel;
  final String size;
  final String runTime;
  final String title;
  final String notes;
  final String uid;
  final String track;
  final String date;
  final Map<String, dynamic> engine;

  SetupTile(this.time, this.fuel, this.size, this.runTime, this.title,
      this.notes, this.uid, this.track, this.date, this.engine);
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
                    builder: (context) => ShowSetup(time, fuel, size, runTime,
                        title, notes, uid, track, date, engine)));
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
                        runTime + " min",
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
