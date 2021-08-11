import 'package:flutter/material.dart';
import 'package:voda/screens/index.dart';
import 'package:voda/config.dart';

class ScreenArguments<T> {
  ScreenArguments({
    this.payload,
    this.resetTabState = false,
    this.canPossibleBack = false,
  });

  final T? payload;
  final bool resetTabState;
  final bool canPossibleBack;
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({
    Key? key,
    required this.onNavigation,
    required this.navigatorKey,
    required this.tabIndex,
  }) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  final Function({bool withBottomBar, String? newRoute, String? prevRoute, bool? resetTabState}) onNavigation;
  final int tabIndex;

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
              case '/':
              case '/auth':
                ScreenArguments? args = settings.arguments != null ? settings.arguments as ScreenArguments : null;
                return AuthScreen(canPossibleBack: args?.canPossibleBack ?? false);
              case '/auth/second':
                ScreenArguments<String>? args =
                    settings.arguments != null ? settings.arguments as ScreenArguments<String> : null;
                return AuthSecondScreen(phone: args?.payload ?? '');
              case '/auth/properties':
                return AuthPropertiesScreen();
              case '/main':
                return MainStackScreen(tabIndex: widget.tabIndex, tabCount: 4);
              case '/history/details':
                ScreenArguments<int>? args =
                    settings.arguments != null ? settings.arguments as ScreenArguments<int> : null;
                return HistoryDetailsScreen(historyId: args?.payload ?? 0);
              case '/notifications':
                return NotificationsScreen();
              case '/shoppingcart':
                return ShoppingCartScreen();
              case '/map':
                return MapScreen();
              case '/address':
                return AddressScreen();
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

  final Function({bool withBottomBar, String? newRoute, String? prevRoute, bool? resetTabState}) onNavigation;

  List<String> routesWithoutBottomBar = [
    '/',
    '/auth',
    '/auth/second',
    '/auth/properties',
    '/notifications',
    '/history/details',
    '/catalog/card',
    '/shoppingcart',
    '/map',
    '/address'
  ];

  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String prevRoute = previousRoute?.settings.name ?? '/';
    onNavigation(withBottomBar: !routesWithoutBottomBar.contains(prevRoute), prevRoute: prevRoute);
  }

  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    String newRoute = route.settings.name ?? '/';
    ScreenArguments? args = route.settings.arguments != null ? route.settings.arguments as ScreenArguments : null;

    onNavigation(
      withBottomBar: !routesWithoutBottomBar.contains(newRoute),
      newRoute: newRoute,
      resetTabState: args?.resetTabState,
    );
  }
}
