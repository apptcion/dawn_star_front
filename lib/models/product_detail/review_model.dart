import 'package:flutter/foundation.dart';

class Review{
  final String writer;
  final String content;
  final DateTime date;

  Review({
    required this.writer,
    required this.content,
    required this.date
  });
  factory Review.fromJSON(Map<String, dynamic> json){
    return Review(
      writer: json['writer'],
      content: json['content'],
      date: DateTime.parse(json['date'])
    );
  }
}