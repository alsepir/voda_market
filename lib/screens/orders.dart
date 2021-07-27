import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrdersProvider ordersProvider = Provider.of<OrdersProvider>(context);
    List<OrderModel> orders = ordersProvider.data ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Активные заказы', style: Theme.of(context).appBarTheme.titleTextStyle),
        leading: IconButton(
          icon: CustomIcon(
            CustomIcons.notification,
            color: Theme.of(context).appBarTheme.iconTheme?.color,
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/notifications');
          },
        ),
        actions: [
          IconButton(
            icon: CustomIcon(
              CustomIcons.shoppingCart,
              color: Theme.of(context).appBarTheme.iconTheme?.color,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        cacheExtent: 3000,
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return OrderCard(
            data: orders[index],
            margin: EdgeInsets.fromLTRB(24, 0, 24, index == orders.length - 1 ? 100 : 16),
            onTap: () {
              // Navigator.of(context).pushNamed('/history/details', arguments: orders[index].id);
            },
          );
        },
      ),
    );
  }
}
