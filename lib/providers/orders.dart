import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

List<OrderDetailsModel> generateTwoOrders() {
  return List<OrderDetailsModel>.generate(
    2,
    (i) => OrderDetailsModel(i, 'Вода природная', '2 шт./200₽'),
  );
}

List<OrderDetailsModel> generateFourOrders() {
  return List<OrderDetailsModel>.generate(
    4,
    (i) => OrderDetailsModel(i, 'Вода природная', '2 шт./200₽'),
  );
}

class OrdersProvider with ChangeNotifier {
  OrdersProvider()
      : data = List<OrderModel>.generate(
          1,
          (i) => OrderModel(
            i,
            'Ожидает отправки',
            i % 2 == 0 ? generateFourOrders() : generateTwoOrders(),
            i == 0,
            '21 июня, 19:02',
            i % 2 == 0 ? 800 : 400,
            'Московский пр. 27',
            'Комментарий',
            'Оплата наличными',
            '17:00',
            '18:00',
          ),
        );

  List<OrderModel>? data;
}
