import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/main.dart';
import 'package:uuid/uuid.dart';

import 'saved_engines.dart';

class CreateEngine extends StatefulWidget {
  @override
  _CreateEngineState createState() => _CreateEngineState();
}

double pinione = 14;
String pinioneString = "14";

double corona = 48;
String coronaString = "48";

class _CreateEngineState extends State<CreateEngine> {
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

  Color createButtonColor = Color.fromRGBO(255, 0, 0, 1);

  var _uuid = Uuid();

  TextEditingController nameController = new TextEditingController();
  TextEditingController pipeController = new TextEditingController();
  TextEditingController manifoldController = new TextEditingController();
  TextEditingController clutchController = new TextEditingController();
  TextEditingController venturiController = new TextEditingController();
  TextEditingController litersController = new TextEditingController();

  final _key = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    TextStyle titleStyle =
        GoogleFonts.montserrat(color: Colors.white, fontSize: width * 0.05);
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        title: Text(
          "Create your Engine",
          style: GoogleFonts.montserrat(),
        ),
        elevation: 0,
        backgroundColor: mainColor,
        actions: [
          IconButton(
              icon: FaIcon(
                FontAwesomeIcons.save,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SavedEngines()));
              })
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: Center(
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        Text(
                          "Engine",
                          style: titleStyle,
                        ),
                        Field(
                          controller: nameController,
                          hintText: "Name or Serial Number",
                          index: 0,
                        ),
                        Text(
                          "Pipe",
                          style: titleStyle,
                        ),
                        Field(
                          controller: pipeController,
                          hintText: "Pipe name",
                          index: 1,
                        ),
                        Text(
                          "Manifold",
                          style: titleStyle,
                        ),
                        Field(
                          controller: manifoldController,
                          hintText: "Manifold name",
                          index: 2,
                        ),
                        Text(
                          "Clutch",
                          style: titleStyle,
                        ),
                        Field(
                          controller: clutchController,
                          hintText: "Clutch name",
                          index: 3,
                        ),
                        Text(
                          "Gears",
                          style: titleStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          pinioneString,
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        Center(
                          child: Container(
                            child: Slider.adaptive(
                                activeColor: mainColor,
                                max: 25,
                                min: 10,
                                divisions: 15,
                                value: pinione,
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {
                                    pinione = newValue;
                                    pinioneString = pinione.toInt().toString();
                                  });
                                }),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          coronaString,
                          style: GoogleFonts.montserrat(color: Colors.white),
                        ),
                        Center(
                          child: Container(
                            child: Slider.adaptive(
                                activeColor: mainColor,
                                max: 50,
                                min: 30,
                                divisions: 20,
                                value: corona,
                                onChanged: (newValue) {
                                  print(newValue);
                                  setState(() {
                                    corona = newValue;
                                    coronaString = corona.toInt().toString();
                                  });
                                }),
                          ),
                        ),
                        Text(
                          "Venturi",
                          style: titleStyle,
                        ),
                        Field(
                          controller: venturiController,
                          hintText: "Venturi size",
                          index: 4,
                        ),
                        Text(
                          "Liters",
                          style: titleStyle,
                        ),
                        Field(
                          controller: litersController,
                          hintText: "Liters number",
                          index: 4,
                        ),
                        GestureDetector(
                          onTapDown: (details) {
                            print("pressed");
                            setState(() {
                              createButtonColor = Colors.grey;
                            });
                          },
                          onTapUp: (details) {
                            print("cancelled");
                            setState(() {
                              createButtonColor = mainColor;
                            });
                            createEngine();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            width: width / 3,
                            decoration: BoxDecoration(
                                color: createButtonColor,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Center(
                              child: Text(
                                "Create",
                                style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                    fontSize: width * 0.04),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  bool isLoading = false;

  void createEngine() async {
    if (_key.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        Map<String, dynamic> data = {
          "engine": nameController.text,
          "pipe": pipeController.text,
          "manifold": manifoldController.text,
          "clutch": clutchController.text,
          "pinione": pinione,
          "corona": corona,
          "venturi": venturiController.text,
          "liters": litersController.text,
          "uid": _uuid.v1(),
        };

        await FirebaseFirestore.instance
            .collection("utenti")
            .doc(Constants.myUID)
            .collection("engines")
            .add(data)
            .whenComplete(() {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: "Engine created",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: darkLighterColor,
          );
          setState(() {
            isLoading = false;
          });
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "Please provide the correct data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: darkLighterColor,
        );
        print(e);
      }
    }
  }
}

class Field extends StatelessWidget {
  final controller;
  final hintText;
  final index;

  const Field({Key key, this.controller, this.hintText, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);
    Color mainColor = Color.fromRGBO(255, 0, 0, 1);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: darkLighterColor),
      child: Center(
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (index == 0 || index == 1 || index == 2) {
              if (value.isEmpty) {
                return "Please enter a name";
              } else if (value.length > 25) {
                return "Name is too long";
              }
            } else if (index == 3) {
              if (value.isEmpty) {
                return "Please enter a description";
              } else if (value.length > 40) {
                return "Description is too long";
              }
            } else if (index == 4) {
              if (value.isEmpty) {
                return "Please enter a value";
              }
            }
          },
          style: GoogleFonts.montserrat(color: Colors.white),
          textAlign: TextAlign.center,
          cursorColor: mainColor,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: GoogleFonts.montserrat()),
        ),
      ),
    );
  }
}
