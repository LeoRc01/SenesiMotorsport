import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/pages/strategy.dart';
import 'package:redsracing/storage_sessions/savedsessions.dart';
import 'package:redsracing/storage_setups/savedsetups.dart';
import 'package:redsracing/storage_strategies/savedstrategies.dart';

class ShowStrategy extends StatefulWidget {
  final List<dynamic> strategy;
  final String title;
  final String uid;

  const ShowStrategy({this.strategy, this.title, this.uid});

  @override
  _ShowStrategyState createState() => _ShowStrategyState();
}

class _ShowStrategyState extends State<ShowStrategy> {
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
      ),
      backgroundColor: darkColor,
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  widget.title,
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.07),
                ),
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
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "",
                              style: GoogleFonts.montserrat(
                                fontSize: width * 0.04,
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
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "[min]",
                              style: GoogleFonts.montserrat(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
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
                  itemCount: widget.strategy.length,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: (width / 4) - 10,
                          child: Center(
                            child: Text(
                              widget.strategy[index]["stint"].toString(),
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
                              widget.strategy[index]["lap"].toString(),
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
                              widget.strategy[index]["time"].toString(),
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
                              widget.strategy[index]["margin"].toString(),
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
                  },
                ),
              ),
              SizedBox(
                height: height * 0.01,
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
        .collection("strategies")
        .where("uid", isEqualTo: widget.uid)
        .get()
        .then((snapshot) {
      print(snapshot.docs.toString());
      snapshot.docs.first.reference.delete().whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }).catchError((FirebaseException) => print(FirebaseException));
  }
}
