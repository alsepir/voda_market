import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcons {
  static const String order = 'order';
  static const String water = 'water';
  static const String profile = 'profile';
  static const String calendar = 'calendar';
  static const String phone = 'phone';
  static const String destination = 'destination';
  static const String caretRight = 'caretRight';
  static const String caretLeft = 'caretLeft';
  static const String moon = 'moon';
  static const String notification = 'notification';
  static const String shoppingCart = 'shoppingCart';
  static const String gear = 'gear';
  static const String repeat = 'repeat';
  static const String crosshair = 'crosshair';
  static const String coin = 'coin';
  static const String comment = 'comment';
  static const String plus = 'plus';
  static const String minus = 'minus';
  static const String filter = 'filter';
  static const String sun = 'sun';
}

class CustomIcon extends StatelessWidget {
  CustomIcon(
    this.assetName, {
    Key? key,
    this.width = 24,
    this.height = 24,
    this.color = Colors.grey,
    this.margin,
  }) : super(key: key);

  final String assetName;
  final double width;
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: SvgPicture.asset(
        'assets/icons/$assetName.svg',
        width: width,
        height: height,
        color: color,
      ),
    );
  }
}
