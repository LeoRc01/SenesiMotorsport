import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/logs/loginPage.dart';
import 'package:SenesiMotorsport/pages/loadingpage.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:slide_drawer/slide_drawer.dart';

import 'pages/notesandfoldersPage.dart';
import 'pages/searchItem.dart';
import 'pages/showItemsPage.dart';
import 'pages/yourorders.dart';

Controller colorController = new Controller.colorController();

main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn;

  TextStyle menuItemFont = GoogleFonts.montserrat();

  @override
  void initState() {
    Get.changeTheme(ThemeData.dark());
    woocommerce.isCustomerLoggedIn().then((value) {
      setState(() {
        isLoggedIn = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: Get.theme,

      home: isLoggedIn == null
          ? LoadingPage()
          : isLoggedIn
              // MainPage()
              ? NoteAndFolders("mainpage", "Your folders", "")
              : LoginPage(),
      //home: HttpRequestTest(),
      debugShowCheckedModeBanner: false,
      title: "Senesi Motorsport",
    );
  }
}
