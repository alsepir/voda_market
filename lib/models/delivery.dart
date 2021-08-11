class DeliveryCityModel {
  DeliveryCityModel(this.id, this.label, this.description);

  int id;
  String label;
  String description;
}

class DeliveryFormModel {
  DeliveryFormModel()
      : address = '',
        apartment = '',
        porch = '',
        storey = '',
        comment = '',
        arriveToBuilding = false;

  String address;
  String apartment;
  String porch;
  String storey;
  String comment;
  bool arriveToBuilding;
}
