import 'dart:convert';

import 'package:daystar/models/product_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  Future<ProductInfo> _fetchProductInfo() async {
    return new ProductInfo();
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text('${product.name}'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 300.h,
              color: Color(0xFFF3F1EF),
              child: Center(
                child: Image.memory(
                    product.imgBytes,
                    width : 250.w,
                    fit: BoxFit.fill
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '${product.price}원',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  FutureBuilder(
                    future: _fetchProductInfo(),
                    builder: (context, snapshot){
                      return DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                                indicatorColor: Colors.transparent,
                                labelColor: Color(0xFF333333),
                                unselectedLabelColor: Color(0xFF565656),
                                labelStyle: TextStyle(fontSize: 18.sp),
                                unselectedLabelStyle: TextStyle(fontSize: 18.sp),
                                tabs: [
                                  Tab(text: '상품 정보'),
                                  Tab(text: '리뷰 ${snapshot.data!.review.length}'),
                                  Tab(text: '가치 정보')
                                ]
                            ),

                          ],
                        )
                      );
                    }
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: ElevatedButton(
            onPressed: () {
              // 장바구니 추가 기능 구현
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.w),
              ),
            ),
            child: Text(
              '장바구니에 추가',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoTab extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Text('');
  }
}