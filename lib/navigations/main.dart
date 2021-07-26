import 'package:flutter/material.dart';
import 'package:voda/screens/index.dart';
import 'package:voda/config.dart';

class MainNavigator extends StatefulWidget {
  const MainNavigator({
    Key? key,
    required this.onNavigation,
    required this.navigatorKey,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Function({bool withBottomBar, String? newRoute, String? prevRoute}) onNavigation;

  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: widget.navigatorKey,
      observers: <NavigatorObserver>[
        MainNavigatorObserver(widget.onNavigation),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: AppConfig.routeTransition,
          reverseTransitionDuration: AppConfig.routeReverseTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            double begin = 0.0;
            double end = 1.0;
            Cubic curve = Curves.ease;
            Animatable<double> tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return FadeTransition(
              opacity: animation.drive(tween),
              child: child,
            );
          },
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case '/catalog':
                return CatalogScreen();
              case '/history':
                return HistoryScreen();
              case '/history/details':
                int id = settings.arguments as int;
                return HistoryDetailsScreen(historyId: id);
              case '/profile':
                return ProfileScreen();
              case '/':
              case '/order':
                return OrdersScreen();
              case '/notifications':
                return NotificationsScreen();
              default:
                return UnknownScreen();
            }
          },
        );
      },
    );
  }
}

class MainNavigatorObserver extends NavigatorObserver {
  MainNavigatorObserver(this.onNavigation);

  final Function({bool withBottomBar, String? newRoute, String? prevRoute}) onNavigation;

  List<String> routesWithoutBottomBar = [
    '/notifications',
    '/history/details',
    '/catalog/card',
  ];

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String prevRoute = previousRoute?.settings.name ?? '/';
    onNavigation(withBottomBar: !routesWithoutBottomBar.contains(prevRoute), prevRoute: prevRoute);
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String newRoute = route.settings.name ?? '/';
    onNavigation(withBottomBar: !routesWithoutBottomBar.contains(newRoute), newRoute: newRoute);
  }
}
