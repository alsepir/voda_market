import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/components/index.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
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
                    title: 'Тёмная тема',
                    type: ButtonType.secondary,
                    leading: CustomIcons.moon,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    onPress: () {
                      ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
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
                onPress: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth',
                    (Route<dynamic> route) => false,
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
