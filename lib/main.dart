import 'package:SenesiMotorsport/controllers/getxcontroller.dart';
import 'package:SenesiMotorsport/logs/loginPage.dart';
import 'package:SenesiMotorsport/pages/loadingpage.dart';
import 'package:SenesiMotorsport/pages/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';

Controller colorController = new Controller();

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

  @override
  void initState() {
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
      theme: ThemeData.light(),
      home: isLoggedIn == null
          ? LoadingPage()
          : isLoggedIn
              ? MainPage()
              : LoginPage(),
      //home: HttpRequestTest(),
      debugShowCheckedModeBanner: false,
      title: "Senesi Motorsport",
    );
  }
}
