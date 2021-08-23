import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/index.dart';
import 'providers/index.dart';
import 'theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:voda/models/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppRunProperties appRunProperties = await initApp();
  runApp(App(appRunProperties: appRunProperties));
}

Future<AppRunProperties> initApp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? jsonTheme = prefs.getInt('theme');
  String? jsonProfile = prefs.getString('profile');
  ProfileModel? profile;

  if (jsonProfile != null) {
    Map<String, dynamic> profileMap = jsonDecode(jsonProfile);
    profile = ProfileModel.fromJson(profileMap);
  }

  return AppRunProperties(theme: jsonTheme, profile: profile);
}

class AppRunProperties {
  AppRunProperties({this.theme, this.profile});

  int? theme;
  ProfileModel? profile;
}

class App extends StatelessWidget {
  App({Key? key, this.appRunProperties}) : super(key: key);

  final AppRunProperties? appRunProperties;

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = appRunProperties?.theme == 2 ? ThemeMode.dark : ThemeMode.light;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider(mode: themeMode)),
        ChangeNotifierProvider(create: (context) => ProfileProvider(data: appRunProperties?.profile)),
        ChangeNotifierProvider(create: (context) => NotificationsProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => OrdersProvider()),
        ChangeNotifierProvider(create: (context) => CatalogProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingCartProvider()),
        ChangeNotifierProvider(create: (context) => DeliveryProvider()),
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
    );
  }
}
