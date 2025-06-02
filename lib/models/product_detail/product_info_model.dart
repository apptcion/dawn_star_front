import 'package:daystar/models/product_detail/review_model.dart';

class ProductInfo{
  late List<Review> review;
  late String info;
  late String valueInfo;
  ProductInfo({
    required this.info,
    required this.valueInfo,
    required List<Map<String, dynamic>> review
  }){
    this.review = review.map((data) => Review.fromJSON(data)).toList();
  }
}