import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/models/index.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';

class ChipsTheme {
  ChipsTheme.light()
      : color = AppColors.typographySecondary,
        colorActive = AppColors.white,
        border = AppColors.border.withOpacity(0.08),
        shadow = AppColors.brandBlue.withOpacity(0.5),
        active = AppColors.brandBlue,
        background = AppColors.backgroundPrimary;
  ChipsTheme.dark()
      : color = AppColors.typographyDarkSecondary,
        colorActive = AppColors.typographyPrimary,
        border = AppColors.borderDark.withOpacity(0.08),
        shadow = AppColors.white.withOpacity(0.3),
        active = AppColors.white,
        background = AppColors.backgroundDarkPrimary;

  final Color color;
  final Color colorActive;
  final Color background;
  final Color active;
  final Color border;
  final Color shadow;
}

class Chips extends StatefulWidget {
  Chips({Key? key, required this.item}) : super(key: key);

  final CatalogFilterModel item;

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  bool active = false;

  ChipsTheme getTheme(bool isDark) {
    if (isDark) return ChipsTheme.dark();
    return ChipsTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ChipsTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return InkWell(
      onTap: () {
        setState(() => active = !active);
      },
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 44,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: active ? 16 : 15),
        decoration: BoxDecoration(
          color: active ? theme.active : theme.background,
          borderRadius: BorderRadius.circular(100),
          border: active ? null : Border.all(color: theme.border),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: theme.shadow,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          widget.item.title,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: active ? theme.colorActive : theme.color),
        ),
      ),
    );
  }
}
