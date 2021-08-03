import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';

class ShoppingCartProvider with ChangeNotifier {
  ShoppingCartProvider()
      : cart = [],
        highlightedItems = 0,
        bottlesPrice = 0,
        bottleQuantity = 0,
        bottleReturnQuantity = 0,
        totalPrice = 0,
        totalQuantity = 0;

  List<ShoppingCartModel> cart;
  int highlightedItems;
  int bottlesPrice;
  int bottleQuantity;
  int bottleReturnQuantity;
  int totalPrice;
  int totalQuantity;

  void addItem(CatalogModel item, int amount) {
    bool needAddItem = true;

    List<ShoppingCartModel> newCart = cart.map((element) {
      if (element.id == item.id) {
        needAddItem = false;
        return ShoppingCartModel(id: item.id, amount: amount, item: item);
      } else
        return element;
    }).toList();

    if (needAddItem)
      cart.add(ShoppingCartModel(id: item.id, amount: amount, item: item));
    else
      cart = newCart;
    notifyListeners();
  }

  void changeAmount(CatalogModel item, int amount) {
    List<ShoppingCartModel> newCart = cart.map((element) {
      if (element.id == item.id) {
        element.amount = amount;
        return element;
      } else
        return element;
    }).toList();

    cart = newCart;
    notifyListeners();
    calculatePrice();
  }

  void highlightItem(int id, {bool isLongPress = false}) {
    List<ShoppingCartModel> _cart = cart.map((element) {
      if (element.id == id) {
        element.selected = isLongPress;
        if (isLongPress)
          highlightedItems++;
        else if (highlightedItems > 0) highlightedItems--;
      }
      return element;
    }).toList();

    cart = _cart;
    notifyListeners();
  }

  void clear() {
    if (highlightedItems == 0)
      cart.clear();
    else {
      highlightedItems = 0;
      cart = cart.where((e) => e.selected == false).toList();
    }

    notifyListeners();
  }

  void reset() {
    if (highlightedItems > 0) {
      cart = cart.map((e) {
        e.selected = false;
        return e;
      }).toList();
    }

    highlightedItems = 0;
    bottleReturnQuantity = 0;
    notifyListeners();
  }

  void calculatePrice() {
    int _bottleQuantity = 0;
    int _waterPrice = 0;
    bottlesPrice = cart.fold<int>(0, (prev, element) {
      int _price = 0;
      if (element.amount >= 1) _price = element.amount == 1 ? element.item.priceForOne : element.item.priceForTwo;

      _waterPrice += element.amount * _price;
      _bottleQuantity += element.amount;
      return prev + (element.item.bottlePrice * element.amount);
    });

    totalPrice = bottlesPrice + _waterPrice;
    bottleQuantity = _bottleQuantity;
    totalQuantity = _bottleQuantity * 2;
    notifyListeners();
  }

  void setBottleReturnQuantity(int amount) {
    bottleReturnQuantity = amount;
    notifyListeners();
  }
}
