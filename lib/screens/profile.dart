import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/providers/theme.dart';
import 'package:voda/components/index.dart';
import 'package:voda/theme.dart';
import 'package:voda/navigations/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  late AnimationController _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
  late ThemeMode currentTheme;
  late Offset switcherOffset = Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);

  @override
  void initState() {
    super.initState();
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    currentTheme = themeProvider.mode;
    if (currentTheme == ThemeMode.dark) _controller.value = 1.0;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildScreen(context),
        AnimatedBuilder(
          animation: _controller,
          child: _buildScreen(context, theme: ThemeMode.dark),
          builder: (_, child) {
            return ClipPath(
              clipper: MyClipper(
                sizeRate: _controller.value,
                offset: switcherOffset.translate(0, 0),
              ),
              child: child,
            );
          },
        ),
      ],
    );
  }

  Widget _buildScreen(BuildContext context, {ThemeMode theme = ThemeMode.light}) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    bool needAuth = profileProvider.data == null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme == ThemeMode.dark ? AppColors.backgroundDarkPrimary : AppColors.backgroundPrimary,
      appBar: Header(
        title: 'Профиль',
        theme: theme,
        leading: HeaderLeading.notification,
        actions: [
          Consumer<ShoppingCartProvider>(
            builder: (context, shoppingCart, child) {
              int quantity = shoppingCart.cart.length;
              return IconButton(
                icon: CustomIcon(
                  CustomIcons.shoppingCart,
                  withBadge: quantity > 0,
                  badgeValue: quantity,
                ),
                onPressed: () => Navigator.of(context).pushNamed('/shoppingcart'),
              );
            },
          ),
        ],
      ),
      body: needAuth
          ? NoAuth(
              info: true,
              margin: EdgeInsets.fromLTRB(24, 0, 24, 100),
            )
          : CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: [
                              ProfileCard(
                                theme: theme,
                              ),
                            ],
                          ),
                        ),
                        Listener(
                          onPointerDown: (event) {
                            switcherOffset = Offset(event.position.dx, event.position.dy);
                          },
                          child: Button(
                            title: theme == ThemeMode.light ? 'Тёмная тема' : 'Светлая тема',
                            theme: theme,
                            type: ButtonType.secondary,
                            leading: themeProvider.mode == ThemeMode.light ? CustomIcons.moon : CustomIcons.sun,
                            margin: EdgeInsets.symmetric(vertical: 12),
                            onPress: () {
                              if (theme == ThemeMode.light) _controller.forward();
                              if (theme == ThemeMode.dark) _controller.reverse();
                              ThemeMode nextTheme = theme == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
                              setState(() => currentTheme = nextTheme);
                              if (nextTheme != themeProvider.mode) themeProvider.toggleMode();
                            },
                          ),
                        ),
                        Button(
                          theme: theme,
                          title: 'Информация о приложении',
                          type: ButtonType.secondary,
                          margin: EdgeInsets.only(bottom: 12),
                          onPress: () => {},
                        ),
                        Button(
                          theme: theme,
                          title: 'Выйти',
                          type: ButtonType.exit,
                          onPress: () => showExitDialog(context),
                        ),
                        SizedBox(height: 100)
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<dynamic> showExitDialog(BuildContext context) {
    Modal dialog = Modal(
      title: 'Вы точно хотите выйти?',
      children: [
        Row(
          children: [
            Expanded(
              child: Button(
                title: 'Нет',
                type: ButtonType.secondary,
                onPress: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Button(
                title: 'Да, точно',
                type: ButtonType.exit,
                onPress: () async {
                  ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                  await profileProvider.removeData();

                  Navigator.of(context, rootNavigator: true).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/auth',
                    (Route<dynamic> route) => false,
                    arguments: ScreenArguments(resetTabState: true),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );

    return showDialog(
        context: context,
        routeSettings: RouteSettings(name: '/profile/exit'),
        builder: (BuildContext context) {
          return dialog;
        });
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper({required this.sizeRate, required this.offset});
  final double sizeRate;
  final Offset offset;

  @override
  Path getClip(Size size) {
    var path = Path()
      ..addOval(
        Rect.fromCircle(center: offset, radius: size.height * sizeRate),
      );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
