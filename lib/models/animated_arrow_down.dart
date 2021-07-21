import 'package:SenesiMotorsport/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedArrowDown extends StatefulWidget {
  @override
  _AnimatedArrowDownState createState() => _AnimatedArrowDownState();
}

class _AnimatedArrowDownState extends State<AnimatedArrowDown>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _positionController;

  @override
  void initState() {
    _animationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 500));

    _positionController = new TweenSequence<double>(
      [
        TweenSequenceItem(tween: Tween(begin: -20, end: -15), weight: 15),
        TweenSequenceItem(tween: Tween(begin: -15, end: -20), weight: 15),
      ],
    ).animate(_animationController);

    _animationController.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Positioned(
          top: _positionController.value,
          left: 0,
          right: 0,
          child: Icon(FontAwesomeIcons.arrowDown, color: AppColors.darkColor),
        );
      },
    );
  }
}
