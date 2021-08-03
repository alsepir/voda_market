class CatalogModel {
  CatalogModel(
    this.id,
    this.title,
    this.volume,
    this.description,
    this.priceForOne,
    this.priceForTwo,
    this.bottlePrice,
    this.image,
  );

  int id;
  String title;
  int volume;
  String description;
  int priceForOne;
  int priceForTwo;
  String image;
  int bottlePrice;
}

class CatalogFilterModel {
  CatalogFilterModel(
    this.id,
    this.title,
  );

  int id;
  String title;
}

class CatalogAdvertisingModel {
  CatalogAdvertisingModel(
    this.id,
    this.title,
    this.image,
  );

  int id;
  String title;
  String image;
}
