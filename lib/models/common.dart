class ListItemModel {
  ListItemModel(this.id, this.label);

  int id;
  String label;

  ListItemModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        label = json['label'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
      };
}
