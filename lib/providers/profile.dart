import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class ProfileProvider with ChangeNotifier {
  ProfileProvider();

  ProfileModel? data;
  String? authPhone;
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

  setData(String name, int cityId) {
    ListItemModel? city = cities?[cityId];

    if (city == null) return;

    data = ProfileModel(
      name,
      '+7 $authPhone',
      ListItemModel(city.id, 'г. ${city.label}'),
    );
    notifyListeners();
  }
}
