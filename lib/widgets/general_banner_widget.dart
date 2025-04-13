import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GeneralBannerWidget extends StatelessWidget {
  const GeneralBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 261.h,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            '일반 배너',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
} 