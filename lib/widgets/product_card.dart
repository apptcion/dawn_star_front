import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool showBrand;
  const ProductCard({super.key, required this.product, this.showBrand = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.w),
          child: Container(
            width: 170.w,
            height: 170.h,
            color: const Color(0xFFF3F1EF),
            child: Image.memory(product.imgBytes),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: 170.w,
          child: Text(
            product.name,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          width: 170.w,
          child: Text(
            '${product.price}원',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (showBrand) ...[
          SizedBox(height: 10.h),
          SizedBox(
            width: 170.w,
            child: Text(
              product.brand,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ],
    );
  }
}