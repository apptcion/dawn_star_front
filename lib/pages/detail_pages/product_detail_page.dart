import 'package:daystar/models/product_detail/product_info_model.dart';
import 'package:daystar/models/product_detail/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  Future<ProductInfo> _fetchProductInfo() async {
    return ProductInfo(
        info: 'info',
        valueInfo: 'ValueInfo',
        review: [{'writer': 'awd', 'content': 'content', 'date': DateTime.now().toString()}]
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.brand,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    )
                  ),
                  Column(
                    children: [
                      SizedBox(height: 2.5.h),
                      Icon(Icons.arrow_forward_ios,
                          size: 14.w,color: Color(0xFF808080))
                    ],
                  )
                ]
              )
            ),
            SizedBox(
              height: 3.h,
              child: Container(
                color: Color(0xFFF6F6F6)
              )
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                   '${product.price}원',
                    style: TextStyle(
                    fontSize: 17.sp,
                     fontWeight: FontWeight.bold,
                     color: Colors.black,
                    ),
                  )
                ]
              )
            ),
            SizedBox(
                height: 3.h,
                child: Container(
                    color: Color(0xFFF6F6F6)
                )
            ),
            FutureBuilder<ProductInfo>(
              future: _fetchProductInfo(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('에러 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return Center(child: Text('데이터가 없습니다.'));
                } else {
                  final product = snapshot.data!;

                  return DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Colors.transparent,
                          dividerColor: Color(0xFFF6F6F6),
                          dividerHeight: 3.h,
                          labelColor: Color(0xFF333333),
                          unselectedLabelColor: Color(0xFF565656),
                          labelStyle: TextStyle(fontSize: 18.sp),
                          unselectedLabelStyle: TextStyle(fontSize: 18.sp),
                          tabs: [
                            Tab(text: '상품 정보'),
                            Tab(text: '리뷰 ${product.review.length}'),
                            Tab(text: '가치 정보'),
                          ],
                        ),
                        SizedBox(
                          height: 500.h, // 원하는 높이로 설정
                          child: TabBarView(
                            children: [
                              InfoTab(product.info),
                              ReviewTab(product.review),
                              ValueInfoTab(product.valueInfo),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            )
          ]
        )
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
  final String info;
  const InfoTab(this.info, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            info,
            style: TextStyle(
              fontSize: 20.h
            )
        )
    );
  }
}

class ValueInfoTab extends StatelessWidget{
  final String valueInfo;
  const ValueInfoTab(this.valueInfo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
            valueInfo,
            style: TextStyle(
                fontSize: 20.h
            )
        )
    );
  }
}

class ReviewTab extends StatelessWidget{
  final List<Review> reviews;

  const ReviewTab(this.reviews, {super.key});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: reviews.map((data) => Comment(data)).toList()
      )
    );
  }
}

class Comment extends StatelessWidget {
  final Review comment;

  const Comment(this.comment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('writer : ${comment.writer}, content: ${comment.content}, date: ${comment.date}')
    );
  }
}
