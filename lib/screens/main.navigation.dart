import 'package:voda/navigations/main.dart';
import 'package:flutter/material.dart';
import 'package:voda/components/icon.dart';

class MainNavigationScreen extends StatefulWidget {
  MainNavigationScreen({Key? key, required this.tab}) : super(key: key);

  final String tab;

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen>
    with TickerProviderStateMixin<MainNavigationScreen> {
  late AnimationController _hide;
  int currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _hide = AnimationController(vsync: this, duration: kThemeAnimationDuration);
  }

  @override
  void dispose() {
    _hide.dispose();
    super.dispose();
  }

  int parseTabIndex(String route, int current) {
    List<String> routeFragments = route.split('/');
    String firstFragment = routeFragments[1];

    switch (firstFragment) {
      case '':
      case 'order':
        return 0;
      case 'catalog':
        return 1;
      case 'history':
        return 2;
      case 'profile':
        return 3;
      default:
        return current;
    }
  }

  void onNavigation({bool withBottomBar = true, String? newRoute, String? prevRoute}) {
    if (withBottomBar)
      _hide.forward();
    else
      _hide.reverse();

    int newIndex = currentIndex;

    if (newRoute != null) {
      newIndex = parseTabIndex(newRoute, currentIndex);
    }

    if (prevRoute != null) {
      newIndex = parseTabIndex(prevRoute, currentIndex);
    }

    if (newIndex != currentIndex) {
      setState(() => currentIndex = newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigatorKey.currentState?.maybePop();
        return false;
      },
      child: Scaffold(
        body: Stack(fit: StackFit.expand, children: [
          MainNavigator(onNavigation: onNavigation, navigatorKey: navigatorKey),
          Align(
            alignment: Alignment(0.0, 0.96),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FadeTransition(
                  opacity: _hide,
                  child: SizeTransition(
                    sizeFactor: _hide,
                    axis: Axis.vertical,
                    child: _buildBottomNavigationBar(context),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      unselectedFontSize: 10,
      currentIndex: currentIndex,
      onTap: (index) {
        if (currentIndex == index) return;
        String routeName = '/';

        switch (index) {
          case 0:
            routeName = true ? '/order' : '/catalog';
            break;
          case 1:
            routeName = true ? '/catalog' : '/history';
            break;
          case 2:
            routeName = true ? '/history' : '/profile';
            break;
          case 3:
            routeName = '/profile';
            break;
        }

        setState(() => currentIndex = index);
        navigatorKey.currentState?.pushNamed(routeName);
      },
      items: [
        BottomNavigationBarItem(
          icon: _buildBottomNavigationIcon(context, 0, CustomIcons.order),
          label: 'Заказы',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: _buildBottomNavigationIcon(context, 1, CustomIcons.water),
          label: 'Каталог',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: _buildBottomNavigationIcon(context, 2, CustomIcons.calendar),
          label: 'История',
          tooltip: '',
        ),
        BottomNavigationBarItem(
          icon: _buildBottomNavigationIcon(context, 3, CustomIcons.profile),
          label: 'Профиль',
          tooltip: '',
        )
      ],
    );
  }

  Widget _buildBottomNavigationIcon(BuildContext context, int index, String iconName) {
    return CustomIcon(
      iconName,
      width: 32,
      height: 32,
      color: index == currentIndex
          ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
          : Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
    );
  }
}
