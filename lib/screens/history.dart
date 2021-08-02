import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/navigations/main.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';
import 'package:voda/theme.dart';

class HistoryScreenTheme {
  HistoryScreenTheme.light() : this.helper = AppColors.typographyTertiary;
  HistoryScreenTheme.dark() : this.helper = AppColors.typographyDarkTertiary;

  final Color helper;
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  HistoryScreenTheme getTheme(bool isDark) {
    if (isDark) return HistoryScreenTheme.dark();
    return HistoryScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    List<HistoryModel> history = historyProvider.data ?? [];
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    bool needAuth = profileProvider.data == null;
    HistoryScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('История заказов', style: Theme.of(context).appBarTheme.titleTextStyle),
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
      body: needAuth
          ? Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
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
                  SizedBox(height: 100),
                ],
              ),
            )
          : ListView.builder(
              cacheExtent: 3000,
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                return HistoryCard(
                  data: history[index],
                  margin: EdgeInsets.fromLTRB(24, 0, 24, index == history.length - 1 ? 100 : 16),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/history/details',
                      arguments: ScreenArguments<int>(payload: history[index].id),
                    );
                  },
                );
              },
            ),
    );
  }
}
