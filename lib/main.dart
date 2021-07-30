import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/index.dart';
import 'providers/index.dart';
import 'theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
        ChangeNotifierProvider(create: (context) => CatalogProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) {
          return MaterialApp(
            home: MainNavigationScreen(),
            theme: themeLight,
            darkTheme: themeDark,
            themeMode: theme.mode,
          );
        },
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
