import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:voda/components/index.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/theme.dart';

class MapScreenTheme {
  MapScreenTheme.light()
      : value = AppColors.typographyPrimary,
        placeholder = AppColors.typographyTertiary,
        background = AppColors.backgroundSecondary,
        position = AppColors.backgroundPrimary,
        positionIcon = AppColors.brandBlue,
        positionShadow = AppColors.black.withOpacity(0.25);
  MapScreenTheme.dark()
      : value = AppColors.typographyDarkPrimary,
        placeholder = AppColors.typographyDarkTertiary,
        background = AppColors.darkGrey6,
        position = AppColors.backgroundDarkPrimary,
        positionIcon = AppColors.brandDarkBlue,
        positionShadow = AppColors.black.withOpacity(0.25);

  final Color value;
  final Color placeholder;
  final Color background;
  final Color position;
  final Color positionIcon;
  final Color positionShadow;
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  static const Point _pointCheboksary = Point(latitude: 56.132692, longitude: 47.251786);

  YandexMapController? _controller;
  String address = '';
  LocationPermission? _permission;
  Placemark? _placemark;

  @override
  void initState() {
    super.initState();
    locationPermission();
  }

  MapScreenTheme getTheme(bool isDark) {
    if (isDark) return MapScreenTheme.dark();
    return MapScreenTheme.light();
  }

  Future<void> locationPermission() async {
    _permission = await Geolocator.checkPermission();
    if (_permission == LocationPermission.denied) {
      _permission = await Geolocator.requestPermission();
    }
  }

  void setCurrentLocation() async {
    bool serviceEnabled;

    if (_permission == LocationPermission.denied) {
      await locationPermission();
      if (_permission == LocationPermission.denied) return;
      showUserLayer();
    }

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      Point point = Point(latitude: position.latitude, longitude: position.longitude);
      await moveToPoint(point, 18);
    }
  }

  Future<void> showUserLayer() async {
    await _controller?.showUserLayer(
      iconName: 'assets/images/map/user.png',
      arrowName: 'assets/images/map/arrow.png',
      accuracyCircleFillColor: Colors.transparent,
      userArrowOrientation: false,
    );
  }

  Future<void> moveToPoint(Point point, double zoom) async {
    await _controller?.move(
      point: point,
      zoom: zoom,
      animation: const MapAnimation(smooth: true, duration: 2.0),
    );
  }

  Future<void> setPlacemark(Point point) async {
    if (_placemark != null) await _controller?.removePlacemark(_placemark!);

    _placemark = Placemark(
      point: point,
      onTap: (Placemark self, Point point) => print('Tapped me at ${point.latitude},${point.longitude}'),
      style: const PlacemarkStyle(
        opacity: 0.7,
        iconName: 'assets/images/map/location.png',
        scale: 0.7,
      ),
    );

    await _controller?.addPlacemark(_placemark!);
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);
    MapScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);
    double bottomFrameHeight = address.isNotEmpty ? 146.0 : 90.0;
    double bottomMaskGradient = bottomFrameHeight - 16.0;
    double bottomLocationPosition = bottomFrameHeight + 26;

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
                      await moveToPoint(_pointCheboksary, 12);
                      await showUserLayer();
                    },
                    onMapTap: (Point point) {
                      print('Tapped map at ${point.latitude},${point.longitude}');
                      setPlacemark(point);
                    },
                  ),
                ),
              ),
              Container(height: bottomFrameHeight, color: Colors.white),
            ],
          ),
          Positioned(
            bottom: bottomMaskGradient,
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
                          return MapBottomSheet(
                            initValue: address,
                            onSelect: (item) {
                              setState(() => address = item.label);
                              deliveryProvider.address = item.label;
                            },
                          );
                        },
                      );
                    },
                  ),
                  if (address.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Button(
                      title: 'Далее',
                      type: ButtonType.primary,
                      onPress: () {
                        Navigator.of(context).pushNamed('/address');
                      },
                    ),
                  ],
                  SizedBox(height: address.isNotEmpty ? 16 : 24),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: bottomLocationPosition,
            left: 16,
            child: Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: theme.position,
                boxShadow: [
                  BoxShadow(
                    color: theme.positionShadow,
                    spreadRadius: 0,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                borderRadius: BorderRadius.circular(22),
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => setCurrentLocation(),
                  child: Align(
                    alignment: Alignment.center,
                    child: CustomIcon(CustomIcons.paperPlane, color: theme.positionIcon),
                  ),
                ),
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
