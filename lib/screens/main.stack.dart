import 'package:flutter/material.dart';
import 'package:voda/screens/index.dart';
import 'package:voda/config.dart';

class MainStackScreen extends StatefulWidget {
  const MainStackScreen({
    Key? key,
    required this.tabIndex,
    required this.tabCount,
  }) : super(key: key);

  final int tabIndex;
  final int tabCount;

  @override
  _MainStackScreenState createState() => _MainStackScreenState();
}

class _MainStackScreenState extends State<MainStackScreen> with TickerProviderStateMixin<MainStackScreen> {
  late List<AnimationController> _faders;
  late List<int> screensIndex;

  @override
  void initState() {
    super.initState();
    screensIndex = List.generate(widget.tabCount, (index) => index);
    _faders = screensIndex.map((e) => AnimationController(vsync: this, duration: AppConfig.routeTransition)).toList();
    _faders[widget.tabIndex].value = 1.0;
  }

  @override
  void dispose() {
    for (AnimationController controller in _faders) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: screensIndex.map(
        (index) {
          final Widget view = FadeTransition(
            opacity: _faders[index].drive(CurveTween(curve: Curves.ease)),
            child: _buildScreen(context, index),
          );
          if (index == widget.tabIndex) {
            _faders[index].forward();
            return view;
          } else {
            _faders[index].reverse();
            if (_faders[index].isAnimating) {
              return IgnorePointer(child: view);
            }
            return Offstage(child: view);
          }
        },
      ).toList(),
    );
  }

  Widget _buildScreen(BuildContext context, int tabIndex) {
    if (tabIndex == 0)
      return OrdersScreen();
    else if (tabIndex == 1)
      return CatalogScreen();
    else if (tabIndex == 2)
      return HistoryScreen();
    else if (tabIndex == 3)
      return ProfileScreen();
    else
      return UnknownScreen();
  }
}
