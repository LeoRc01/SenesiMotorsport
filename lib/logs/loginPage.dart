import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: height * 0.3,
                width: width,
                child: Center(
                  child: Image.asset("assets/senesi-motorsport-logo.png"),
                ),
              ),
              Form(
                key: _key,
                child: Container(
                  width: Get.width,
                  child: Column(
                    children: [
                      InputTextTile("Email", emailController),
                      InputTextTile("Password", passwordController),
                      GestureDetector(
                        onTap: () async {
                          const _url =
                              'https://senesimotorsport.com/my-account/lost-password';

                          await canLaunch(_url)
                              ? await launch(_url)
                              : throw 'Could not launch $_url';
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  const _url = 'https://senesimotorsport.com/my-account/';

                  await canLaunch(_url)
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.center,
                  child: Text(
                    "Register",
                    style: GoogleFonts.montserrat(
                        color: AppColors.darkLighterColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  login();
                },
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: height * 0.07,
                  width: width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1),
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

  login() async {
    if (_key.currentState.validate()) {
      try {
        Get.off(() => MainPage(), transition: Transition.zoom);
      } catch (e) {
        Get.snackbar("", null,
            titleText: Text(
              "Error",
              style: GoogleFonts.montserrat(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            messageText: Text(
              "Something went wrong. Try login again with the correct data.",
              style: GoogleFonts.montserrat(color: Colors.white),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}

class InputTextTile extends StatelessWidget {
  final hintText;
  final controller;
  InputTextTile(this.hintText, this.controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: AppColors.darkColor),
      child: TextFormField(
        validator: (value) {
          if (hintText == "Email") {
            if (!value.isEmail) {
              return "Please enter a valid email";
            }
          }
          if (value.isEmpty) {
            return "Please provide all the data needed";
          }
        },
        keyboardType: hintText == "Email"
            ? TextInputType.emailAddress
            : TextInputType.text,
        obscureText: hintText != "Email" ? true : false,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          hintText: hintText.toString(),
          hintStyle: GoogleFonts.montserrat(color: Colors.grey),
        ),
        style: GoogleFonts.montserrat(color: Colors.white),
      ),
    );
  }
}
