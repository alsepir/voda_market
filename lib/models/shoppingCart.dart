import 'index.dart';

class ShoppingCartModel {
  ShoppingCartModel({
    required this.id,
    required this.amount,
    required this.item,
    this.selected = false,
  });

  int id;
  int amount;
  CatalogModel item;
  bool selected;
}
