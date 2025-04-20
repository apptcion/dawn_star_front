import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UpcyclingVideoCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final int views;
  final int likes;
  const UpcyclingVideoCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.views,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.w),
          child: Container(
            width: 361.w,
            height: 203.h,
            color: Colors.grey[300],
            child: imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                );
              },
            )
                : null,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 361.w,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 361.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '조회수 $views',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D7D7D),
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                '좋아요 $likes',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF7D7D7D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}