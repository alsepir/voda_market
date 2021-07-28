import 'package:flutter/material.dart';

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
            onGenerateRoute: onGenerateRoute,
            theme: themeLight,
            darkTheme: themeDark,
            themeMode: theme.mode,
            initialRoute: '/auth',
          );
        },
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case '/':
          case '/main':
            return MainNavigationScreen();
          case '/auth':
            return AuthScreen();
          case '/auth/second':
            final ScreenArguments<String> args = settings.arguments;
            return AuthSecondScreen(phone: args.payload != null ? args.payload! : '');
          default:
            return Text('bad');
        }
      },
    );
  }
}

class ScreenArguments<T> {
  ScreenArguments({this.payload});

  final T? payload;
}
