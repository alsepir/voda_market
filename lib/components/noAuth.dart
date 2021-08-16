import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/components/index.dart';
import 'package:voda/navigations/main.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';

class NoAuthTheme {
  NoAuthTheme.light() : this.helper = AppColors.typographyTertiary;
  NoAuthTheme.dark() : this.helper = AppColors.typographyDarkTertiary;

  final Color helper;
}

class NoAuth extends StatelessWidget {
  const NoAuth({Key? key, this.margin, this.info = false}) : super(key: key);

  final EdgeInsets? margin;
  final bool info;

  NoAuthTheme getTheme(bool isDark) {
    if (isDark) return NoAuthTheme.dark();
    return NoAuthTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    NoAuthTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Container(
      margin: margin,
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Text(
                'Данная вкладка недоступна неавторизованным пользователям',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, height: 1.29, color: theme.helper),
              ),
            ),
          ),
          Button(
            title: 'Авторизоваться',
            type: ButtonType.primary,
            onPress: () {
              Navigator.of(context).pushNamed(
                '/auth',
                arguments: ScreenArguments(canPossibleBack: true),
              );
            },
          ),
          if (info) ...[
            SizedBox(height: 12),
            Button(
              title: 'Информация о приложении',
              type: ButtonType.secondary,
              onPress: () => {},
            ),
          ]
        ],
      ),
    );
  }
}
