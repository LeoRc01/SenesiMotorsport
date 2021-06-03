import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_engines/create_engine.dart';
import 'package:uuid/uuid.dart';
import 'package:carousel_slider/carousel_slider.dart';

class SaveSetup extends StatefulWidget {
  final String time;
  final String fuel;
  final String size;
  final String runTime;

  SaveSetup(this.time, this.fuel, this.size, this.runTime);

  @override
  _SaveSetupState createState() => _SaveSetupState();
}

int selectedEngineIndex = 0;
CarouselController buttonCarouselController = CarouselController();

class _SaveSetupState extends State<SaveSetup> {
  var _key = new GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();
  TextEditingController trackController = new TextEditingController();

  var uuid = Uuid();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getEngines();
    super.initState();
  }

  QuerySnapshot enginesQuerySnapshot;
  List<dynamic> allEngines = [];
  getEngines() async {
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("engines")
        .get()
        .then((value) {
      setState(() {
        enginesQuerySnapshot = value;
        isLoading = false;
      });
      populateEngineList();
    }).catchError((onError) => print(onError));
  }

  void populateEngineList() {
    for (var i = 0; i < enginesQuerySnapshot.docs.length; i++) {
      allEngines.add(enginesQuerySnapshot.docs[i].data());
    }
    print(allEngines);
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
        title: Text("Save Your Fuel Mileage", style: GoogleFonts.montserrat()),
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
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: width,
                      color: darkLighterColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: GoogleFonts.montserrat(color: Colors.white),
                            controller: titleController,
                            validator: (value) {
                              if (value.isEmpty) return "Please insert a title";
                            },
                            decoration: InputDecoration(
                              hintText: "Title",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.montserrat(),
                            ),
                            cursorColor: mainColor,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      width: width,
                      color: darkLighterColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: GoogleFonts.montserrat(color: Colors.white),
                            controller: trackController,
                            decoration: InputDecoration(
                              hintText: "Track",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.montserrat(),
                            ),
                            validator: (value) {
                              if (value.isEmpty) return "Please insert a track";
                            },
                            cursorColor: mainColor,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: width,
                      color: darkLighterColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            style: GoogleFonts.montserrat(color: Colors.white),
                            minLines: 6,
                            maxLines: 10,
                            controller: notesController,
                            decoration: InputDecoration(
                              hintText:
                                  "Notes (e.g. Engine temperature, Grip conditions...)",
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.montserrat(),
                            ),
                            cursorColor: mainColor,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
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
                                  "Estimated run time",
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
                                Text(
                                  widget.runTime + " min",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.05),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
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
                                  "Elapsed time",
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
                                Text(
                                  widget.time.replaceAll(".", ":") + " min",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.05),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
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
                                  "Remaining fuel",
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
                                Text(
                                  widget.fuel + " ml",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.05),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
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
                                  "Fuel tank size",
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
                                Text(
                                  widget.size + " ml",
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.05),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      width: width,
                      color: darkLighterColor,
                      child: allEngines.isNotEmpty
                          ? Row(
                              children: [
                                Container(
                                  width: width / 2 - 20,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Engine",
                                            style: GoogleFonts.montserrat(
                                                color: Colors.white,
                                                fontSize: width * 0.045),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  buttonCarouselController
                                                      .previousPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          curve: Curves.linear);
                                                },
                                                icon: FaIcon(
                                                  FontAwesomeIcons.chevronUp,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  buttonCarouselController
                                                      .nextPage(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  300),
                                                          curve: Curves.linear);
                                                },
                                                icon: FaIcon(
                                                  FontAwesomeIcons.chevronDown,
                                                  size: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
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
                                      MySlider(allEngines: allEngines),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Container(
                                  width: width / 2 - 20,
                                  child: Text(
                                    "No engines found",
                                    style: GoogleFonts.montserrat(
                                        color: mainColor,
                                        fontSize: width * 0.045),
                                  ),
                                ),
                                Container(
                                  width: width / 2 - 20,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateEngine()));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 50),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15),
                                      width: width * 0.3,
                                      decoration: BoxDecoration(
                                        color: Colors.greenAccent[700],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Create engine",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          savedata();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Save",
                              style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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

  savedata() async {
    if (_key.currentState.validate()) {
      String dateFormat = DateFormat("dd/MM/yyyy").format(DateTime.now());
      print(DateTime.now());
      Map<String, dynamic> emptyEngine = {};
      var selectedEngine =
          allEngines.isNotEmpty ? allEngines[selectedEngineIndex] : emptyEngine;
      Map<String, dynamic> data = {
        "title": titleController.text.trim(),
        "notes": notesController.text.trim(),
        "estimated_run_time": widget.runTime,
        "elapsed_time": widget.time,
        "remaining_fuel": widget.fuel,
        "date": dateFormat,
        "track": trackController.text,
        "fuel_tank_size": widget.size,
        "uid": uuid.v1(),
        "engine": selectedEngine,
      };
      await FirebaseFirestore.instance
          .collection("utenti")
          .doc(Constants.myUID)
          .collection("setups")
          .doc(uuid.v1())
          .set(data)
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

class MySlider extends StatefulWidget {
  List<dynamic> allEngines = [];

  MySlider({Key key, this.allEngines}) : super(key: key);

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          viewportFraction: 0.4,
          scrollDirection: Axis.vertical,
          initialPage: 0,
          onPageChanged: (index, reason) {
            setState(() {
              selectedEngineIndex = index;
              print("SELECTED ENGINE INDEX: " + selectedEngineIndex.toString());
            });
          },
        ),
        items: widget.allEngines.map((i) {
          return Builder(
            builder: (context) {
              return GestureDetector(
                onLongPress: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Engine info",
                                style: GoogleFonts.montserrat(
                                    color: mainColor,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.05,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                i['engine'],
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Text(
                                "Manifold: " + i['manifold'],
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Text(
                                "Pipe: " + i['pipe'],
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Text(
                                i['pinione'].toString().substring(0, 2) +
                                    "/" +
                                    i['corona'].toString().substring(0, 2),
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Text(
                                "Venturi: " + i['venturi'],
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Text(
                                "Liters: " + i['liters'].toString(),
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: mainColor,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Back",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
                child: Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width / 2,
                  child: Text(
                    i['engine'].toString(),
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                ),
              );
            },
          );
        }).toList());
  }
}
