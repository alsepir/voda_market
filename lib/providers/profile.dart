import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider()
      : data = ProfileModel(
          'Пётр Петрович',
          '+7 (999) 999-99-99',
          ListItemModel(0, 'г. Чебоксары'),
        );

  ProfileModel? data;
  List<ListItemModel>? cities = [
    ListItemModel(0, 'Чебоксары'),
    ListItemModel(1, 'Новочебоксарск'),
  ];

  changeName(String? value) {
    data?.name = value ?? '';
    notifyListeners();
  }

  changePhone(String? value) {
    data?.phone = value ?? '';
    notifyListeners();
  }

  changeCity(int? id) {
    ListItemModel city = (cities ?? []).where((element) => element.id == id).toList()[0];
    data?.city = ListItemModel(city.id, 'г. ${city.label}');
    notifyListeners();
  }
}
