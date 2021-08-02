import 'common.dart';

class ProfileModel {
  ProfileModel(this.name, this.phone, this.city);

  String name;
  String phone;
  ListItemModel city;

  ProfileModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        city = ListItemModel.fromJson(json['city']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'city': city.toJson(),
      };
}
