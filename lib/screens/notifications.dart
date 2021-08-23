import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voda/components/index.dart';
import 'package:voda/providers/index.dart';
import 'package:voda/models/index.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationsProvider notificationsProvider = Provider.of<NotificationsProvider>(context);
    List<NotificationModel> notifications = notificationsProvider.data ?? [];

    return Scaffold(
      appBar: Header(
        title: 'Уведомления',
        leading: HeaderLeading.back,
        actions: [
          IconButton(
            icon: CustomIcon(CustomIcons.gear),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.separated(
        cacheExtent: 3000,
        itemCount: notifications.length,
        separatorBuilder: (BuildContext context, int index) =>
            Divider(height: 1, thickness: 0.5, indent: 24, endIndent: 24),
        itemBuilder: (BuildContext context, int index) {
          return NotificationsCard(data: notifications[index]);
        },
      ),
    );
  }
}
