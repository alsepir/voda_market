import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/components/index.dart';

class ChipsBadgeTheme {
  ChipsBadgeTheme.light()
      : color = AppColors.white,
        badgeBackground = AppColors.brandBlue,
        background = AppColors.backgroundSecondary,
        icon = AppColors.typographyPrimary;
  ChipsBadgeTheme.dark()
      : color = AppColors.white,
        badgeBackground = AppColors.brandDarkBlue,
        background = AppColors.backgroundDarkSecondary,
        icon = AppColors.typographyDarkPrimary;

  final Color color;
  final Color icon;
  final Color background;
  final Color badgeBackground;
}

class ChipsBadge extends StatelessWidget {
  ChipsBadge({Key? key, this.amount}) : super(key: key);

  final int? amount;

  ChipsBadgeTheme getTheme(bool isDark) {
    if (isDark) return ChipsBadgeTheme.dark();
    return ChipsBadgeTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ChipsBadgeTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Container(
      height: 44,
      width: 44,
      decoration: BoxDecoration(
        color: theme.background,
        shape: BoxShape.circle,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: CustomIcon(
              CustomIcons.filter,
              color: theme.icon,
            ),
          ),
          if (amount != null && amount! > 0)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                height: 16,
                width: 16,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.badgeBackground,
                  shape: BoxShape.circle,
                ),
                child: Text('$amount',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: theme.color)),
              ),
            ),
        ],
      ),
    );
  }
}
