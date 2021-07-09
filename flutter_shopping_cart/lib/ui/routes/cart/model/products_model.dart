// To parse this JSON data, do
//
//     final productsModel = productsModelFromJson(jsonString);

import 'dart:convert';

ProductsModel productsModelFromJson(str) => ProductsModel.fromJson(json.decode(str));

class ProductsModel {
  ProductsModel({
    this.categories,
  });

  Map<String, List<Product>>? categories;

  factory ProductsModel.fromJson(Map<String, dynamic> json) => ProductsModel(
    categories: json["categories"] == null ? null : Map.from(json["categories"]).map((k, v) => MapEntry<String, List<Product>>(k, List<Product>.from(v.map((x) => Product.fromJson(x))))),
  );
}

class Product {
  Product({
    this.id,
    this.name,
    this.modelNumber,
    this.image,
    this.price,
    this.specifications,
  });

  int? id;
  String? name;
  String? modelNumber;
  String? image;
  int? price;
  Map<String, dynamic>? specifications;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"] == null ? null : json["id"],
    name: json["name"] == null ? null : json["name"],
    modelNumber: json["model_number"] == null ? null : json["model_number"],
    image: json["image"] == null ? null : json["image"],
    price: json["price"] == null ? null : json["price"],
    specifications: json["specifications"] == null ? null : Map.from(json["specifications"]).map((k, v) => MapEntry<String, dynamic>(k, v)),
  );
}