class OrderModel {
  OrderModel(
    this.id,
    this.label,
    this.details,
    this.mayReturn,
    this.date,
    this.price,
    this.target,
    this.comment,
    this.howpay,
    this.dateBegin,
    this.dateEnd,
  );

  int id;
  String label;
  String dateBegin;
  String dateEnd;
  List<OrderDetailsModel> details;
  String date;
  int price;
  bool mayReturn;
  String target;
  String howpay;
  String comment;
}

class OrderDetailsModel {
  OrderDetailsModel(this.id, this.label, this.description);

  int id;
  String label;
  String description;
}
