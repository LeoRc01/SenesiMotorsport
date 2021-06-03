import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/storage_engines/show_engine.dart';
import 'package:redsracing/storage_setups/showsetup.dart';
import 'package:uuid/uuid.dart';

class SavedEngines extends StatefulWidget {
  @override
  _SavedEnginesState createState() => _SavedEnginesState();
}

class _SavedEnginesState extends State<SavedEngines> {
  var _key = new GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController notesController = new TextEditingController();

  QuerySnapshot setupsQuerySnapshot;

  @override
  void initState() {
    getEngines();
    super.initState();
  }

  bool isLoading = true;

  Widget setups() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: setupsQuerySnapshot.docs.length,
      itemBuilder: (context, index) {
        return EngineTile(
          engine: setupsQuerySnapshot.docs[index].data(),
        );
      },
    );
  }

  getEngines() async {
    await FirebaseFirestore.instance
        .collection("utenti")
        .doc(Constants.myUID)
        .collection("engines")
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
        title: Text("Engines", style: GoogleFonts.montserrat()),
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
                                "No engines found",
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

class EngineTile extends StatelessWidget {
  final engine;

  const EngineTile({Key key, this.engine}) : super(key: key);

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
                    builder: (context) => ShowEngine(
                          engine: engine,
                        )));
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
                        engine['engine'],
                        style: GoogleFonts.montserrat(
                            color: Colors.white, fontSize: width * 0.045),
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
