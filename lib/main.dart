import 'package:SenesiMotorsport/logs/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: LoginPage(),
      //home: HttpRequestTest(),
      debugShowCheckedModeBanner: false,
      title: "Senesi Motorsport",
    );
  }
}
