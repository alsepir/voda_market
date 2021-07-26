import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

List<HistoryDetailsModel> generateTwo() {
  return List<HistoryDetailsModel>.generate(
    2,
    (i) => HistoryDetailsModel(i, 'Вода природная', '2 шт./200₽'),
  );
}

List<HistoryDetailsModel> generateFour() {
  return List<HistoryDetailsModel>.generate(
    4,
    (i) => HistoryDetailsModel(i, 'Вода природная', '2 шт./200₽'),
  );
}

class HistoryProvider with ChangeNotifier {
  HistoryProvider()
      : data = List<HistoryModel>.generate(
          100,
          (i) => HistoryModel(
            i,
            'Завершен',
            i % 2 == 0 ? generateFour() : generateTwo(),
            i == 0,
            '21 июня, 19:02',
            i % 2 == 0 ? 800 : 400,
            'Московский пр. 27',
            'Комментарий',
            'Оплата наличными',
          ),
        );

  List<HistoryModel>? data;
}
