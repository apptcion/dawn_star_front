import 'package:daystar/models/product_model.dart';
import 'package:daystar/pages/detail_pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ProductCard extends StatelessWidget {
  final Product product;
  final bool showBrand;
  const ProductCard({super.key, required this.product, this.showBrand = true});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => ProductDetailPage(product: product),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
      },
      child: Column(
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
                  fontSize: 14.sp,
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
          ]
      )
    );
  }
}