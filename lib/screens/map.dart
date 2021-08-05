import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:voda/components/index.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';

class MapScreenTheme {
  MapScreenTheme.light()
      : value = AppColors.typographyPrimary,
        placeholder = AppColors.typographyTertiary,
        background = AppColors.backgroundSecondary;
  MapScreenTheme.dark()
      : value = AppColors.typographyDarkPrimary,
        placeholder = AppColors.typographyDarkTertiary,
        this.background = AppColors.darkGrey6;

  final Color value;
  final Color placeholder;
  final Color background;
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  static const Point _pointCheboksary = Point(latitude: 56.132692, longitude: 47.251786);

  YandexMapController? _controller;
  String address = '';

  MapScreenTheme getTheme(bool isDark) {
    if (isDark) return MapScreenTheme.dark();
    return MapScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    MapScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Выберите адрес доставки'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: CustomIcon(
            CustomIcons.caretLeft,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: YandexMap(
                    onMapCreated: (YandexMapController yandexMapController) async {
                      _controller = yandexMapController;
                    },
                    onMapRendered: () async {
                      await _controller!.move(
                        point: _pointCheboksary,
                        zoom: 12,
                        animation: const MapAnimation(smooth: true, duration: 2.0),
                      );
                    },
                    onMapSizeChanged: (MapSize size) => print('Map size changed to ${size.width}x${size.height}'),
                    onMapTap: (Point point) => print('Tapped map at ${point.latitude},${point.longitude}'),
                    onMapLongTap: (Point point) => print('Long tapped map at ${point.latitude},${point.longitude}'),
                  ),
                ),
              ),
              Container(height: 100, color: Colors.white),
            ],
          ),
          Positioned(
            bottom: 84,
            child: Container(
              height: 36,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.red,
                gradient: LinearGradient(
                  begin: Alignment(0.0, -0.8),
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0),
                    Colors.white.withOpacity(0.9),
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                children: [
                  _buildInputButton(
                    context,
                    theme: theme,
                    value: address,
                    placeholder: 'Куда везти?',
                    onTap: () {
                      final AnimationController _controller = AnimationController(
                        duration: const Duration(milliseconds: 30),
                        vsync: this,
                      );

                      showModalBottomSheet<void>(
                        context: context,
                        routeSettings: RouteSettings(name: '/map/address'),
                        isScrollControlled: true,
                        useRootNavigator: true,
                        backgroundColor: Colors.transparent,
                        transitionAnimationController: _controller,
                        builder: (BuildContext context) {
                          return MapBottomSheet(onSelect: (item) => {setState(() => address = item.label)});
                        },
                      );
                    },
                  ),
                  if (address.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Button(
                      title: 'Далее',
                      type: ButtonType.primary,
                      onPress: () {},
                    ),
                  ],
                  SizedBox(height: address.isNotEmpty ? 16 : 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputButton(
    BuildContext context, {
    String value = '',
    String placeholder = '',
    required Function onTap,
    required MapScreenTheme theme,
  }) {
    return GestureDetector(
      onPanDown: (details) => onTap(),
      child: Container(
        height: 52,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value.isNotEmpty ? value : placeholder,
          style: TextStyle(
            color: value.isNotEmpty ? theme.value : theme.placeholder,
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
