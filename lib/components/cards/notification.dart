import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/models/index.dart';

class NotificationsCardTheme {
  NotificationsCardTheme.light()
      : label = AppColors.typographyPrimary,
        description = AppColors.typographySecondary,
        date = AppColors.typographyTertiary;
  NotificationsCardTheme.dark()
      : label = AppColors.typographyDarkPrimary,
        description = AppColors.typographyDarkSecondary,
        date = AppColors.typographyDarkTertiary;

  final Color label;
  final Color description;
  final Color date;
}

class NotificationsCard extends StatelessWidget {
  NotificationsCard({Key? key, required this.data}) : super(key: key);

  final NotificationModel data;

  NotificationsCardTheme getTheme(bool isDark) {
    if (isDark) return NotificationsCardTheme.dark();
    return NotificationsCardTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    NotificationsCardTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return InkWell(
      onTap: () => {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.label, style: TextStyle(color: theme.label)),
                Text(data.date, style: TextStyle(color: theme.date)),
              ],
            ),
            SizedBox(height: 4),
            Row(children: [
              Text(data.description, style: TextStyle(color: theme.description)),
            ]),
          ],
        ),
      ),
    );
  }
}
