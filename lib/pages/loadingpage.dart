import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkColor,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
