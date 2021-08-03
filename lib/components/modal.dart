import 'package:voda/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';

class ModalTheme {
  ModalTheme.light()
      : this.title = AppColors.typographyPrimary,
        this.border = AppColors.border,
        this.background = AppColors.backgroundPrimary;
  ModalTheme.dark()
      : this.title = AppColors.typographyDarkPrimary,
        this.border = AppColors.borderDark,
        this.background = AppColors.backgroundDarkSecondary;

  final Color title;
  final Color border;
  final Color background;
}

class Modal extends StatelessWidget {
  Modal({Key? key, this.children, this.title}) : super(key: key);

  final List<Widget>? children;
  final String? title;

  ModalTheme getTheme(bool isDark) {
    if (isDark) return ModalTheme.dark();
    return ModalTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ModalTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return SimpleDialog(
      title: title != null
          ? Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.title),
              ),
            )
          : null,
      titlePadding: EdgeInsets.symmetric(vertical: 24),
      contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      titleTextStyle: TextStyle(
        color: theme.title,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: theme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: theme.border),
      ),
      children: children,
    );
  }
}
