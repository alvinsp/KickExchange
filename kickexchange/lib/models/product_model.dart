class ProductModel {
  List<Data>? data;

  ProductModel({this.data});

  factory ProductModel.fromJson(List<dynamic> json) {
    List<Data> dataList = json.map((item) => Data.fromJson(item)).toList();
    return ProductModel(data: dataList);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((v) => v.toJson()).toList();
  }

  Data? getProductById(int id) {
    return data?.firstWhere((product) => product.id == id);
  }
}

class Data {
  int? id;
  String? name;
  int? price;
  int? qty;
  int? categoryId;
  String? url;
  bool? isFavorite;
  String? createdBy;

  Data(
      {this.id,
      this.name,
      this.price,
      this.qty,
      this.categoryId,
      this.url,
      this.isFavorite,
      this.createdBy});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        qty: json['qty'],
        categoryId: json['categoryId'],
        url: json['url'],
        isFavorite: json['isFavorite'],
        createdBy: json['createdBy']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'qty': qty,
      'categoryId': categoryId,
      'url': url,
      'isFavorite': isFavorite,
      'createdBy': createdBy,
    };
  }
}
