import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/components/index.dart';
import 'package:voda/models/index.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HistoryProvider historyProvider = Provider.of<HistoryProvider>(context);
    List<HistoryModel> history = historyProvider.data ?? [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('История заказов', style: Theme.of(context).appBarTheme.titleTextStyle),
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
        itemCount: history.length,
        itemBuilder: (BuildContext context, int index) {
          return HistoryCard(
            data: history[index],
            margin: EdgeInsets.fromLTRB(24, 0, 24, index == history.length - 1 ? 100 : 16),
            onTap: () {
              Navigator.of(context).pushNamed('/history/details', arguments: history[index].id);
            },
          );
        },
      ),
    );
  }
}