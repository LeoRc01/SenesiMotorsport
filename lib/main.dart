import 'package:flutter/material.dart';
import 'package:redsracing/pages/mainpage.dart';
import 'package:redsracing/pages/strategy.dart';
import 'package:redsracing/sign/loginpage.dart';
import 'package:redsracing/sign/registerpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    checkLog();
    super.initState();
  }

  bool log = false;
  bool loading = true;

  SharedPreferences prefs;

  Color mainColor = Color.fromRGBO(255, 0, 0, 1);

  checkLog() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      loading = false;
    });
    //setState(() {
    //log = prefs.getBool("login") ?? true;
    //loading = false;
    //});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Reds Racing",
      theme: ThemeData(accentColor: mainColor),
      home: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : prefs.getBool("login") != null
              ? prefs.getBool("login") == true
                  ? MainPage()
                  : LoginPage()
              : LoginPage(),
    );
  }
}
