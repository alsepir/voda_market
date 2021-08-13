import 'package:flutter/material.dart';
import 'package:voda/models/index.dart';
import 'package:date_format/date_format.dart';

class DeliveryProvider with ChangeNotifier {
  DeliveryProvider()
      : cities = List<DeliveryCityModel>.generate(
          25,
          (i) => DeliveryCityModel(i, 'Московский пр. ${i + 2}', 'Чебоксары'),
        ),
        deliveryDays = [
          formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]),
          formatDate(DateTime.now().add(Duration(days: 1)), [yyyy, '-', mm, '-', dd]),
          formatDate(DateTime.now().add(Duration(days: 2)), [yyyy, '-', mm, '-', dd]),
        ],
        address = '',
        apartment = '',
        porch = '',
        storey = '',
        comment = '',
        arriveToBuilding = false,
        totalPrice = 0,
        howPay = 0,
        isPayUponReceipt = false,
        timeRange = [],
        date = '';

  List<DeliveryCityModel> cities;
  String address;
  String apartment;
  String porch;
  String storey;
  String comment;
  bool arriveToBuilding;
  List<String> deliveryDays;
  int totalPrice;
  int howPay;
  bool isPayUponReceipt;
  List<String> timeRange;
  String date;

  sendForm() {
    DeliveryFormModel form = DeliveryFormModel(
      address: address,
      apartment: apartment,
      porch: porch,
      storey: storey,
      comment: comment,
      arriveToBuilding: arriveToBuilding,
      totalPrice: totalPrice,
      howPay: howPay,
      isPayUponReceipt: isPayUponReceipt,
      timeRange: timeRange,
      date: date,
    );
  }
}
