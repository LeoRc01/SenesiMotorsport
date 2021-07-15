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
              ? SlideDrawer(
                  headDrawer: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/senesi-motorsport-logo.png",
                      alignment: Alignment.centerLeft,
                      height: Get.height * 0.103,
                    ),
                  ),
                  backgroundColor: AppColors.mainColor,
                  /*backgroundGradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    colors: [
                      Color(0xFF000046),
                      Color(0xFF1CB5E0),
                    ],
                  ),*/
                  items: [
                    MenuItem('Search Item', icon: FontAwesomeIcons.search,
                        onTap: () {
                      Get.to(() => SearchItemPage());
                    }),
                    MenuItem('Your Items', icon: FontAwesomeIcons.listAlt,
                        onTap: () {
                      Get.to(() => ShowItemsPage.comingFromPage(true));
                    }),
                    MenuItem('Your orders', icon: FontAwesomeIcons.user,
                        onTap: () {
                      Get.to(() => YourOrders());
                    }),
                    MenuItem('Notes', icon: FontAwesomeIcons.stickyNote,
                        onTap: () {
                      Get.to(() => NoteAndFolders("mainpage", "Your folders"));
                    }),
                    MenuItem('Log out', icon: FontAwesomeIcons.signOutAlt,
                        onTap: () {
                      woocommerce.logUserOut();
                      Get.off(() => LoginPage());
                    }),
                  ],
                  child: MainPage())
              : LoginPage(),
      //home: HttpRequestTest(),
      debugShowCheckedModeBanner: false,
      title: "Senesi Motorsport",
    );
  }
}
