class CategoryModel {
  List<DataCategory>? data;

  CategoryModel({this.data});

  factory CategoryModel.fromJson(List<dynamic> json) {
    List<DataCategory> dataList =
        json.map((item) => DataCategory.fromJson(item)).toList();
    return CategoryModel(data: dataList);
  }

  List<Map<String, dynamic>> toJson() {
    return data!.map((v) => v.toJson()).toList();
  }
}

class DataCategory {
  int? id;
  String? name;
  String? image;

  DataCategory({this.id, this.name, this.image});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataCategory &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  factory DataCategory.fromJson(Map<String, dynamic> json) {
    return DataCategory(
        id: json['id'], name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
