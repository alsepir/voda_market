import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileProvider with ChangeNotifier {
  ProfileProvider({this.data});

  ProfileModel? data;
  String? authPhone;
  List<ListItemModel>? cities = [
    ListItemModel(0, 'Чебоксары'),
    ListItemModel(1, 'Новочебоксарск'),
  ];

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString('profile');

    if (json == null) return;

    Map<String, dynamic> profileMap = jsonDecode(json);
    data = ProfileModel.fromJson(profileMap);
  }

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

  setData(String name, int cityId) async {
    ListItemModel? city = cities?[cityId];

    if (city == null) return;
    data = ProfileModel(name, '+7 $authPhone', ListItemModel(city.id, 'г. ${city.label}'));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = jsonEncode(data);
    await prefs.setString('profile', json);
  }

  Future<void> removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile');
    data = null;
  }
}
