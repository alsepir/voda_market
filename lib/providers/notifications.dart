import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class NotificationsProvider with ChangeNotifier {
  NotificationsProvider()
      : data = List<NotificationModel>.generate(
          100,
          (i) => NotificationModel(i, 'Заголовок', 'Текст', '21 июня, 19:02'),
        );

  List<NotificationModel>? data;
}
