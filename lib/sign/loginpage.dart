import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/sign/passresetpage.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  bool isLoading = false;

  Color darkColor = Color.fromRGBO(30, 30, 30, 1);
  Color mainColor = Color.fromRGBO(255, 0, 0, 1);
  Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: darkColor,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    width: width,
                    height: height / 4,
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      child: Center(
                        child: Image.asset(
                          "assets/redslogo.png",
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    height: (height / 4) * 3,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            loginWithGoogle();
                          },
                          child: Container(
                            width: width,
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(50),
                                color: mainColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.google,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text("CONTINUE WITH GOOGLE",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, letterSpacing: 2))
                              ],
                            ),
                          ),
                        ),
                        Platform.isIOS
                            ? GestureDetector(
                                onTap: () {
                                  loginWithApple();
                                },
                                child: Container(
                                  width: width,
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                      //border: Border.all(
                                      //  color: Colors.white, width: 1.5),
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.black),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.apple,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text("CONTINUE WITH APPLE",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              letterSpacing: 2))
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        GestureDetector(
                          onTap: () {
                            //loginWithApple();
                            enterAsAGuest();
                          },
                          child: Container(
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("CONTINUE AS A GUEST",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, letterSpacing: 2))
                              ],
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: width / 2.6,
                              height: 1,
                              color: Colors.grey[600],
                            ),
                            Text(
                              "o",
                              style: GoogleFonts.montserrat(),
                            ),
                            Container(
                              width: width / 2.6,
                              height: 1,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                        Form(
                          key: _key,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Email address",
                                    style: GoogleFonts.montserrat(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w400)),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(color: Colors.white
                                    //border:
                                    //  Border.all(color: Colors.grey[600], width: 1),
                                    ),
                                child: TextFormField(
                                  cursorColor: mainColor,
                                  style: GoogleFonts.montserrat(),
                                  controller: emailController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter a valid email.";
                                    }
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email address",
                                      hintStyle: GoogleFonts.montserrat(
                                          fontSize: width * 0.03)),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text("Password",
                                    style: GoogleFonts.montserrat(
                                        fontSize: width * 0.04,
                                        fontWeight: FontWeight.w400)),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  //border:
                                  //  Border.all(color: Colors.grey[600], width: 1),
                                ),
                                child: TextFormField(
                                  cursorColor: mainColor,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Please enter a valid password.";
                                    }
                                  },
                                  style: GoogleFonts.montserrat(),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle: GoogleFonts.montserrat(
                                          fontSize: width * 0.03)),
                                ),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PasswordResetPage(),
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Forgot password?",
                                      style: GoogleFonts.montserrat(
                                          color: Colors.black45,
                                          decoration: TextDecoration.underline,
                                          fontSize: width * 0.03,
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  login();
                                },
                                child: Container(
                                  height: height * 0.06,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: darkColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("LOGIN",
                                          style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              letterSpacing: 2))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          width: width,
                          height: 1,
                          color: Colors.grey[600],
                        ),
                        Text("Don't have an account?",
                            style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: height * 0.06,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: darkColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("REGISTER",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white, letterSpacing: 2))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void enterAsAGuest() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("login", true);
    prefs.setString("UID", "GUEST");
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainPage()));
  }

  bool isSigningIn = false;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Future loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = await googleSignIn.signIn();
      if (user == null) {
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        final googleAuth = await user.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) async {
          print("EMAIL: " + value.user.email);
          Map<String, dynamic> data = {"email": value.user.email};

          await FirebaseFirestore.instance
              .collection("utenti")
              .doc(value.user.uid)
              .set(data);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("login", true);
          prefs.setString("UID", value.user.uid);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        });

        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loginWithApple() async {
    if (await SignInWithApple.isAvailable()) {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final provider = OAuthProvider('apple.com');
      final cred = provider.credential(
          idToken: credential.identityToken,
          accessToken: credential.authorizationCode);

      await FirebaseAuth.instance
          .signInWithCredential(cred)
          .then((value) async {
        Map<String, dynamic> data = {"email": value.user.email};

        await FirebaseFirestore.instance
            .collection("utenti")
            .doc(value.user.uid)
            .set(data);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("login", true);
        prefs.setString("UID", value.user.uid);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      });
      print(cred);
    } else {
      Fluttertoast.showToast(
        msg: "Apple sign in not available.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: darkLighterColor,
      );
    }
  }

  Future<void> login() async {
    print(emailController.text);
    print(passwordController.text);
    if (_key.currentState.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text, password: passwordController.text)
            .then((value) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("login", true);
          prefs.setString("UID", value.user.uid);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
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
