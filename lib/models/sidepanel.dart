import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';

class SidePanel extends StatefulWidget {
  String text;

  SidePanel({this.text});

  @override
  _SidePanelState createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _positionAnimation;
  Animation<double> _positionAnimationRev;

  bool isMoving = false;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    _positionAnimation = new TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -50, end: 0), weight: 50),
      //TweenSequenceItem(tween: Tween(begin: 0, end: -50), weight: 50),
    ]).animate(_animationController);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          isMoving = true;
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          isMoving = false;
        });
      }
    });

    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    //_animationController.reverse();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value,
          child: DragTarget(
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: Get.height / 1.5,
                width: 50,
                decoration: BoxDecoration(
                  color: colorController.getBackGroundColorTheme(),
                  boxShadow: isMoving ? [BoxShadow(blurRadius: 50)] : null,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(200),
                    bottomRight: Radius.circular(200),
                  ),
                ),
                child: Center(
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: Text(
                      widget.text,
                      style: GoogleFonts.montserrat(
                          color: colorController.getTextColorTheme(),
                          letterSpacing: 5),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
