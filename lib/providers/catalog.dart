import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class CatalogProvider with ChangeNotifier {
  CatalogProvider()
      : data = List<CatalogModel>.generate(
          100,
          (i) => CatalogModel(i, 'Природная', 19, 'Артезианская питьевая негазированная', 120, 100,
              i % 2 == 0 ? 'assets/images/bottle.png' : 'assets/images/bottle_2.png'),
        ),
        filters = [
          CatalogFilterModel(0, 'Вода'),
          CatalogFilterModel(1, 'Кулеры'),
          CatalogFilterModel(2, 'Аксессуары'),
          CatalogFilterModel(3, 'Ручки'),
          CatalogFilterModel(4, 'Крышки'),
          CatalogFilterModel(5, 'Сумки'),
        ],
        advertising = [
          CatalogAdvertisingModel(
              0, 'При покупке \n2 бутылей воды \nпомпа в подарок', 'assets/images/advertising_1.png'),
          CatalogAdvertisingModel(1, 'Летняя\nраспродажа \nкулеров', 'assets/images/advertising_2.png'),
          CatalogAdvertisingModel(
              2, 'При покупке \n2 бутылей воды \nпомпа в подарок', 'assets/images/advertising_1.png'),
          CatalogAdvertisingModel(3, 'Летняя\nраспродажа\nкулеров', 'assets/images/advertising_2.png'),
          CatalogAdvertisingModel(
              4, 'При покупке \n2 бутылей воды \nпомпа в подарок', 'assets/images/advertising_1.png'),
        ];

  List<CatalogModel>? data;
  List<CatalogFilterModel>? filters;
  List<CatalogAdvertisingModel>? advertising;
}
