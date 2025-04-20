import 'dart:convert';
import 'dart:typed_data';

import 'package:daystar/models/product_model.dart';

class Brand {
  final String id;
  final String name;
  final List<Product>? products;
  late Uint8List brandImg;

  Brand({
    required this.id,
    required this.name,
    this.products,
    required String brandImgStr
  }){
    this.brandImg = base64Decode(brandImgStr);
  }

  factory Brand.fromJSON(Map<String, dynamic> json) {
    print('brandName : ' + json['brand_name']);

    return Brand(
      id: json['_id'],
      name: json['brand_name'],
      brandImgStr: json['logo'],
      products: json['products'] != null
          ? (json['products'] as List)
          .map((product) => Product.fromJSON(product))
          .toList()
          : [],
    );
  }
}