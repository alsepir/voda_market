import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class DeliveryProvider with ChangeNotifier {
  DeliveryProvider()
      : cities = List<DeliveryCityModel>.generate(
          25,
          (i) => DeliveryCityModel(i, 'Московский пр. ${i + 2}', 'Чебоксары'),
        );

  List<DeliveryCityModel> cities;
}
