import 'dart:convert';
import 'dart:typed_data';


class BannerModel {
  final String id;
  final String type;
  late Uint8List imgBytes;

  BannerModel({
    required this.id,
    required this.type,
    required String base64Str
  }){
    imgBytes = base64Decode(base64Str);
  }

  factory BannerModel.fromJSON(Map<String, dynamic> json){
    return BannerModel(
        id: json['_id'],
        type: json['type'],
        base64Str: json['img'],
    );
  }
}