import 'package:flutter/material.dart';

class UpcyclingVideoCard extends StatelessWidget {
  final String title;
  final int views;
  final int likes;
  const UpcyclingVideoCard({super.key, required this.title, required this.views, required this.likes});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('조회수 $views · 좋아요 $likes'),
      ),
    );
  }
}