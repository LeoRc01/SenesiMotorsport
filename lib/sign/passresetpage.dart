import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redsracing/backend/constants.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/sign/passresetpage.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:redsracing/sign/registrationcomplete.dart';

import 'loginpage.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController emailController = new TextEditingController();
  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: darkColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).padding.top),
            alignment: Alignment.topLeft,
            child: IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: Container(
                    width: width * 0.5,
                    child: Image.asset("assets/redslogo.png"),
                  ),
                ),
                Column(
                  children: [
                    Center(
                        child: Text("Insert your email",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: width * 0.08,
                                fontWeight: FontWeight.bold))),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: TextFormField(
                            style: GoogleFonts.montserrat(),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: GoogleFonts.montserrat(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      resetPassword();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      width: width * 0.3,
                      decoration: BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Reset",
                          style: GoogleFonts.montserrat(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  resetPassword() async {
    if (emailController.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text)
            .then((value) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
          Fluttertoast.showToast(
            msg: "Email has been sent!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor: darkLighterColor,
          );
        });
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Please insert a valid email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 1,
          backgroundColor: darkLighterColor,
        );
      }
    }
  }
}
