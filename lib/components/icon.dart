import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';

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
  static const String trash = 'trash';
  static const String checkbox = 'checkbox';
  static const String paperPlane = 'paperPlane';
}

enum CustomIconBadge { red, blue }

class CustomIconTheme {
  CustomIconTheme.light(CustomIconBadge badgeType)
      : badge = AppColors.white,
        badgeBackground = badgeType == CustomIconBadge.blue ? AppColors.brandBlue : AppColors.systemRed;
  CustomIconTheme.dark(CustomIconBadge badgeType)
      : badge = AppColors.white,
        badgeBackground = badgeType == CustomIconBadge.blue ? AppColors.brandDarkBlue : AppColors.systemDarkRed;

  final Color badgeBackground;
  final Color badge;
}

class CustomIcon extends StatelessWidget {
  CustomIcon(
    this.assetName, {
    Key? key,
    this.width = 24,
    this.height = 24,
    this.color = Colors.grey,
    this.margin,
    this.withBadge = false,
    this.badgeValue,
    this.badgeType = CustomIconBadge.blue,
  }) : super(key: key);

  final String assetName;
  final double width;
  final double height;
  final Color? color;
  final EdgeInsetsGeometry? margin;
  final bool withBadge;
  final int? badgeValue;
  final CustomIconBadge badgeType;

  CustomIconTheme getTheme(bool isDark, CustomIconBadge badgeType) {
    if (isDark) return CustomIconTheme.dark(badgeType);
    return CustomIconTheme.light(badgeType);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    CustomIconTheme theme = getTheme(themeProvider.mode == ThemeMode.dark, badgeType);
    int? _badgeValue = badgeValue != null && badgeValue! > 99 ? 99 : badgeValue;

    return Stack(
      children: [
        Container(
          margin: margin,
          child: SvgPicture.asset(
            'assets/icons/$assetName.svg',
            width: width,
            height: height,
            color: color,
          ),
        ),
        if (withBadge)
          Transform.translate(
            offset: Offset(12, -4),
            child: Container(
              height: 16,
              width: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.badgeBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_badgeValue ?? ''}',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: theme.badge),
              ),
            ),
          ),
      ],
    );
  }
}
