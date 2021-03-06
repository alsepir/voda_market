import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/navigations/main.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    List<HistoryModel> history = historyProvider.data ?? [];
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    bool needAuth = profileProvider.data == null;

    return Scaffold(
      appBar: Header(
        title: 'История заказов',
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
              margin: EdgeInsets.fromLTRB(24, 0, 24, 100),
            )
          : ListView.builder(
              cacheExtent: 3000,
              itemCount: history.length,
              itemBuilder: (BuildContext context, int index) {
                return HistoryCard(
                  data: history[index],
                  margin: EdgeInsets.fromLTRB(24, 0, 24, index == history.length - 1 ? 100 : 16),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/history/details',
                      arguments: ScreenArguments<int>(payload: history[index].id),
                    );
                  },
                );
              },
            ),
    );
  }
}
