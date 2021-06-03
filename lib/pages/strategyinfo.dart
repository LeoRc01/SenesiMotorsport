import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:redsracing/main.dart';

class StrategyInfo extends StatefulWidget {
  @override
  _StrategyInfoState createState() => _StrategyInfoState();
}

class _StrategyInfoState extends State<StrategyInfo> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final safeAreaHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom;
    Color darkColor = Color.fromRGBO(30, 30, 30, 1);
    Color mainColor = Color.fromRGBO(255, 0, 0, 1);
    Color darkLighterColor = Color.fromRGBO(59, 59, 59, 1);
    TextStyle title = GoogleFonts.montserrat(
        color: Color.fromRGBO(255, 0, 0, 1),
        fontWeight: FontWeight.bold,
        fontSize: MediaQuery.of(context).size.width * 0.06);
    TextStyle desc = GoogleFonts.montserrat(
        color: Colors.white,
        fontWeight: FontWeight.w400,
        fontSize: MediaQuery.of(context).size.width * 0.036);
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Race Time",
                    style: title,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "The total race duration in minutes (e.g. 45)",
                    style: desc,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "Average Lap Time",
                    style: title,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "Your average lap time on the track in seconds (e.g. 36.7)",
                    style: desc,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "Refuel Lap Time",
                    style: title,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "The lap time you do when you come in the pits (e.g. 42, usually about 6/7 seconds slower)",
                    style: desc,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "Total Fuel Mileage",
                    style: title,
                  ),
                  SizedBox(
                    height: safeAreaHeight * 0.02,
                  ),
                  Text(
                    "Your total fuel mileage in minutes (e.g 8:30)",
                    style: desc,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
