class HistoryModel {
  HistoryModel(
    this.id,
    this.label,
    this.details,
    this.mayReturn,
    this.date,
    this.price,
    this.target,
    this.comment,
    this.howpay,
  );

  int id;
  String label;
  List<HistoryDetailsModel> details;
  String date;
  int price;
  bool mayReturn;
  String target;
  String howpay;
  String comment;
}

class HistoryDetailsModel {
  HistoryDetailsModel(this.id, this.label, this.description);

  int id;
  String label;
  String description;
}
