import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class DeliveryProvider with ChangeNotifier {
  DeliveryProvider()
      : cities = List<DeliveryCityModel>.generate(
          25,
          (i) => DeliveryCityModel(i, 'Московский пр. ${i + 2}', 'Чебоксары'),
        ),
        address = '',
        apartment = '',
        porch = '',
        storey = '',
        comment = '',
        arriveToBuilding = false;

  List<DeliveryCityModel> cities;
  String address;
  String apartment;
  String porch;
  String storey;
  String comment;
  bool arriveToBuilding;
}
