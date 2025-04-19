import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

class Product {
  final String id;
  final String name;
  final String brand;
  late Uint8List imgBytes;
  late String price;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required String base64Str,
    required int priceNumber
  }){
    imgBytes = base64Decode(base64Str);
    price = NumberFormat('#,###').format(priceNumber);
  }

  factory Product.fromJSON(Map<String, dynamic> json){

    print("productName : " + json['product_name']);

    return Product(
      id: json['_id'],
      name: json['product_name'],
      brand: json['brand'],
      base64Str: json['img'],
      priceNumber: json['price']
    );
  }
}