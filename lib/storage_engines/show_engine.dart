import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/backend/getController.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_engines/saved_engines.dart';
import 'package:redsracing/storage_setups/savedsetups.dart';

class ShowEngine extends StatefulWidget {
  final engine;

  const ShowEngine({Key key, this.engine}) : super(key: key);

  @override
  _ShowEngineState createState() =>
      _ShowEngineState(int.parse(engine['liters'].toString()));
}

Color darkColor = Color.fromRGBO(30, 30, 30, 1);
Color mainColor = Color.fromRGBO(255, 0, 0, 1);
Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

class _ShowEngineState extends State<ShowEngine> {
  var _key = new GlobalKey<FormState>();
  //TextEditingController titleController;
  //TextEditingController notesController;
  Controller modificationController;

  TextEditingController engineNameController;
  TextEditingController manifoldController;
  TextEditingController pipeController;
  TextEditingController clutchController;
  TextEditingController venturiController;

  double pinion;
  double corona;

  int newLiters;

  _ShowEngineState(this.newLiters);

  @override
  void initState() {
    pinion = widget.engine['pinione'];
    corona = widget.engine['corona'];

    engineNameController = new TextEditingController();
    engineNameController.text = widget.engine['engine'];

    manifoldController = new TextEditingController();
    manifoldController.text = widget.engine['manifold'];

    pipeController = new TextEditingController();
    pipeController.text = widget.engine['pipe'];

    clutchController = new TextEditingController();
    clutchController.text = widget.engine['clutch'];

    venturiController = new TextEditingController();
    venturiController.text = widget.engine['venturi'];

    //TODO: implement gears controller and liters controller

    modificationController = new Controller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    TextStyle textStyle =
        GoogleFonts.montserrat(color: Colors.white, fontSize: width * 0.05);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        actions: [
          Obx(() => modificationController.getChanged()
              ? IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.check,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    //TODO: update content
                    updateData();
                  })
              : Container())
        ],
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    EditableInfoTile.title(
                        modificationController,
                        engineNameController,
                        GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: width * 0.07,
                        ),
                        true),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
                                  "Manifold",
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: width / 2 - 20,
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EditableInfoTile(modificationController,
                                    manifoldController, textStyle),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      width: width,
                      color: darkLighterColor,
                      child: Row(
                        children: [
                          Container(
                            width: width / 2 - 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text("Pipe", style: textStyle)],
                            ),
                          ),
                          Container(
                            width: width / 2 - 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                EditableInfoTile(modificationController,
                                    pipeController, textStyle),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
                                  "Clutch",
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
                                EditableInfoTile(modificationController,
                                    clutchController, textStyle),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 7),
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
                                  "Venturi",
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
                                EditableInfoTile(modificationController,
                                    venturiController, textStyle),
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
                    /*Container(
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
                                  "Gears",
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
                                  widget.engine['pinione']
                                          .toString()
                                          .substring(0, 2) +
                                      "/" +
                                      widget.engine['corona']
                                          .toString()
                                          .substring(0, 2),
                                  style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: width * 0.05),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),*/
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      pinion.toStringAsFixed(0),
                      style: textStyle,
                    ),
                    Center(
                      child: Container(
                        child: Slider.adaptive(
                            activeColor: mainColor,
                            max: 25,
                            min: 10,
                            divisions: 15,
                            value: pinion,
                            onChanged: (newValue) {
                              setState(() {
                                pinion = newValue;
                              });
                              modificationController.setChanged(true);
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      corona.toStringAsFixed(0),
                      style: textStyle,
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
                              setState(() {
                                corona = newValue;
                              });
                              modificationController.setChanged(true);
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: .5,
                      height: 0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                                  "Liters",
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.minus,
                                          color: Colors.white,
                                          size: width * 0.03,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newLiters--;
                                          });
                                          modificationController
                                              .setChanged(true);
                                        }),
                                    Text(
                                      newLiters.toString(),
                                      style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontSize: width * 0.05),
                                    ),
                                    IconButton(
                                        icon: FaIcon(
                                          FontAwesomeIcons.plus,
                                          color: Colors.white,
                                          size: width * 0.03,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            newLiters++;
                                          });
                                          modificationController
                                              .setChanged(true);
                                        }),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
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

  updateData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("engines")
        .where("uid", isEqualTo: widget.engine['uid'])
        .get()
        .then((value) {
      Map<String, dynamic> data = {
        "liters": newLiters,
        "manifold": manifoldController.text,
        "clutch": clutchController.text,
        "corona": corona,
        "engine": engineNameController.text,
        "pinione": pinion,
        "pipe": pipeController.text,
        "venturi": venturiController.text
      };
      value.docs.first.reference.update(data).then((value) {
        print("updated");
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SavedEngines()));
      }).catchError((onError) {
        print("Error.");
        setState(() {
          isLoading = false;
        });
      });
    }).catchError((onError) {
      print("Error.");
      setState(() {
        isLoading = false;
      });
    });
  }

  bool isLoading = false;
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);
  deleteSetup() async {
    print(widget.engine['uid']);
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection("utenti")
          .doc(Constants.myUID)
          .collection("engines")
          .where("uid", isEqualTo: widget.engine['uid'])
          .get()
          .then((snapshot) {
        setState(() {
          isLoading = true;
        });
        Fluttertoast.showToast(
          msg: "Engine deleted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: darkLighterColor,
        );
        snapshot.docs.first.reference.delete().whenComplete(() {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SavedEngines()));
        });
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: darkLighterColor,
      );
      setState(() {
        isLoading = false;
      });
    }
  }
}

class EditableInfoTile extends StatelessWidget {
  Controller modificationController;
  TextEditingController controller;
  TextStyle style;
  bool isTitle = false;

  EditableInfoTile(this.modificationController, this.controller, this.style);
  EditableInfoTile.title(
      this.modificationController, this.controller, this.style, this.isTitle);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        modificationController.setChanged(true);
      },
      cursorColor: mainColor,
      controller: controller,
      style: style,
      textAlign: isTitle ? TextAlign.center : TextAlign.right,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero, border: InputBorder.none),
    );
  }
}
