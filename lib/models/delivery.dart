class DeliveryCityModel {
  DeliveryCityModel(this.id, this.label, this.description);

  int id;
  String label;
  String description;
}

class DeliveryFormModel {
  DeliveryFormModel({
    required this.address,
    required this.apartment,
    this.porch = '',
    this.storey = '',
    this.comment = '',
    this.arriveToBuilding = false,
    required this.totalPrice,
    required this.howPay,
    this.isPayUponReceipt = false,
    required this.timeRange,
    required this.date,
  });

  String address;
  String apartment;
  String porch;
  String storey;
  String comment;
  bool arriveToBuilding;
  int totalPrice;
  int howPay;
  bool isPayUponReceipt;
  List<String> timeRange;
  String date;
}
