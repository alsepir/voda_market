import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/navigations/main.dart';

class ProfileScreenTheme {
  ProfileScreenTheme.light() : this.helper = AppColors.typographyTertiary;
  ProfileScreenTheme.dark() : this.helper = AppColors.typographyDarkTertiary;

  final Color helper;
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  ProfileScreenTheme getTheme(bool isDark) {
    if (isDark) return ProfileScreenTheme.dark();
    return ProfileScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    bool needAuth = profileProvider.data == null;
    ProfileScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Профиль'),
        leading: IconButton(
          icon: CustomIcon(
            CustomIcons.notification,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/notifications');
          },
        ),
        actions: [
          IconButton(
            icon: CustomIcon(
              CustomIcons.shoppingCart,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed('/shoppingcart');
            },
          ),
        ],
      ),
      body: needAuth
          ? NoAuth(
              info: true,
              margin: EdgeInsets.fromLTRB(24, 0, 24, 100),
            )
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: [
                              ProfileCard(),
                            ],
                          ),
                        ),
                        Button(
                          title: themeProvider.mode == ThemeMode.light ? 'Тёмная тема' : 'Светлая тема',
                          type: ButtonType.secondary,
                          leading: themeProvider.mode == ThemeMode.light ? CustomIcons.moon : CustomIcons.sun,
                          margin: EdgeInsets.symmetric(vertical: 12),
                          onPress: () {
                            themeProvider.toggleMode();
                          },
                        ),
                        Button(
                          title: 'Информация о приложении',
                          type: ButtonType.secondary,
                          margin: EdgeInsets.only(bottom: 12),
                          onPress: () => {},
                        ),
                        Button(
                          title: 'Выйти',
                          type: ButtonType.exit,
                          onPress: () => showExitDialog(context),
                        ),
                        SizedBox(height: 100)
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<dynamic> showExitDialog(BuildContext context) {
    Modal dialog = Modal(
      title: 'Вы точно хотите выйти?',
      children: [
        Row(
          children: [
            Expanded(
              child: Button(
                title: 'Нет',
                type: ButtonType.secondary,
                onPress: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Button(
                title: 'Да, точно',
                type: ButtonType.exit,
                onPress: () async {
                  ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                  await profileProvider.removeData();

                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth',
                    (Route<dynamic> route) => false,
                    arguments: ScreenArguments(resetTabState: true),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );

    return showDialog(
        context: context,
        routeSettings: RouteSettings(name: '/profile/exit'),
        builder: (BuildContext context) {
          return dialog;
        });
  }
}
