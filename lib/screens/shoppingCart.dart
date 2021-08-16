import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';
import 'package:flutter/scheduler.dart';
import 'package:voda/theme.dart';
import 'package:voda/navigations/main.dart';

class ShoppingCartScreenTheme {
  ShoppingCartScreenTheme.light()
      : amount = AppColors.typographyDarkSecondary,
        price = AppColors.typographyDarkPrimary,
        background = AppColors.black;
  ShoppingCartScreenTheme.dark()
      : amount = AppColors.typographySecondary,
        price = AppColors.typographyPrimary,
        background = AppColors.white;

  final Color amount;
  final Color price;
  final Color background;
}

class ShoppingCartScreen extends StatefulWidget {
  ShoppingCartScreen({Key? key}) : super(key: key);

  @override
  _ShoppingCartScreenState createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 600),
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
      shoppingCartProvider.reset();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  ShoppingCartScreenTheme getTheme(bool isDark) {
    if (isDark) return ShoppingCartScreenTheme.dark();
    return ShoppingCartScreenTheme.light();
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context);
    List<ShoppingCartModel> cart = shoppingCartProvider.cart;
    ShoppingCartScreenTheme theme = getTheme(themeProvider.mode == ThemeMode.dark);

    if (shoppingCartProvider.totalQuantity > 0)
      _controller.forward();
    else
      _controller.reverse();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Корзина', style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: CustomIcon(
            CustomIcons.caretLeft,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: CustomIcon(
              CustomIcons.trash,
              withBadge: shoppingCartProvider.highlightedItems > 0,
              badgeValue: shoppingCartProvider.highlightedItems,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () => showClearCartDialog(context),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          ListView.builder(
            cacheExtent: 3000,
            itemCount: cart.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  ShoppingCartCard(
                    data: cart[index],
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    onTap: (ShoppingCartModel item) {
                      if (item.selected) {
                        shoppingCartProvider.highlightItem(item.id);
                      } else {
                        showModalBottomSheet<void>(
                          context: context,
                          routeSettings: RouteSettings(name: '/catalog/card'),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return CatalogBottomSheet(
                              item: cart[index].item,
                              needPriceButton: false,
                              initAmount: cart[index].amount,
                              linkWithProvider: true,
                            );
                          },
                        );
                      }
                    },
                    onLongPress: (ShoppingCartModel item) {
                      if (!item.selected) {
                        shoppingCartProvider.highlightItem(item.id, isLongPress: true);
                      }
                    },
                  ),
                  if (index == cart.length - 1) SizedBox(height: 16),
                  if (index == cart.length - 1)
                    BottlesPriceCard(
                      data: cart[index],
                      margin: EdgeInsets.symmetric(horizontal: 24),
                    ),
                  SizedBox(height: index == cart.length - 1 ? 100 : 16)
                ],
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeTransition(
              opacity: _animation,
              child: SizeTransition(
                sizeFactor: _animation,
                axis: Axis.vertical,
                child: _buildTotalLabel(context, theme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalLabel(BuildContext context, ShoppingCartScreenTheme theme) {
    ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
    DeliveryProvider deliveryProvider = Provider.of<DeliveryProvider>(context, listen: false);

    return Container(
      margin: EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 68,
          padding: EdgeInsets.all(12),
          color: theme.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${shoppingCartProvider.totalQuantity} товаров',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: theme.amount),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${shoppingCartProvider.totalPrice}₽',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: theme.price),
                  ),
                ],
              ),
              Button(
                width: 140,
                title: 'Далее',
                type: ButtonType.theme,
                onPress: () {
                  ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
                  deliveryProvider.totalPrice = shoppingCartProvider.totalPrice;

                  if (profileProvider.data == null) {
                    Navigator.of(context).pushNamed(
                      '/auth',
                      arguments: ScreenArguments(canPossibleBack: true, fromShoppingCart: true),
                    );
                  } else {
                    Navigator.of(context).pushNamed('/map');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showClearCartDialog(BuildContext context) {
    ShoppingCartProvider shoppingCartProvider = Provider.of<ShoppingCartProvider>(context, listen: false);
    int _items = shoppingCartProvider.highlightedItems;

    Modal dialog = Modal(
      title: 'Вы действительно хотите ${_items > 0 ? 'удалить выбранные товары' : 'очистить корзину'}?',
      children: [
        Button(
          title: 'Да${_items > 0 ? ' ($_items)' : ''}',
          type: ButtonType.exit,
          onPress: () {
            shoppingCartProvider.clear();
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
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
