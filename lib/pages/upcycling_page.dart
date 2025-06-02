import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/material_filter_chip.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';
import '../config.dart';

class UpcyclingPage extends StatefulWidget {
  const UpcyclingPage({super.key});

  @override
  State<UpcyclingPage> createState() => _UpcyclingPageState();
}

class _UpcyclingPageState extends State<UpcyclingPage> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<MaterialFilterChipState> _filterChipKey = GlobalKey();
  bool _hasChips = false;
  bool _showDivider = false;

  // 임시 상품 데이터
  late List<Product> _products = [
  ];

  initState(){
    super.initState();
    fetchProducts('eco');
  }

  void fetchProducts(String type) async{
    final response = await http.get(
        Uri.parse('${appConfig.apiUrl}/product/getALL?type=${type}'));
    if (response.statusCode == 200){
      final List<dynamic> jsonList = jsonDecode(response.body);
      setState(() {
        _products = jsonList.map((json) => Product.fromJSON(json)).toList();
      });

    } else{
      throw Exception("failed to load Products");
    }
  }

  void _addChip(String keyword) {
    _filterChipKey.currentState?.addChip(keyword);
    _searchController.clear();
  }

  void _handleChipStateChanged(bool hasChips) {
    if (hasChips) {
      setState(() {
        _hasChips = true;
        _showDivider = true;
      });
    } else {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _hasChips = false;
            _showDivider = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 46.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 7.h, bottom: 17.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'UPCYCLING',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1, thickness: 1, color: Colors.grey),
              Padding(
                padding: EdgeInsets.only(left: 16.w, bottom: 18.h, top: 18.h, right: 22.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 15.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: '키워드를 입력해 보세요.',
                              hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onSubmitted: _addChip,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              _showDivider ? Divider(height: 1, thickness: 1, color: Colors.grey) : SizedBox.shrink(),
              _hasChips
                  ? SizedBox(
                height: 73.h,
                child: MaterialFilterChip(key: _filterChipKey, onChanged: _handleChipStateChanged),
              )
                  : MaterialFilterChip(key: _filterChipKey, onChanged: _handleChipStateChanged),
              Divider(height: 1, thickness: 1, color: Colors.grey),
              SizedBox(
                height: 45.h,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                    insets: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                  labelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  dividerColor: Colors.transparent,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('상품'),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('직접 제작'),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 250.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding: EdgeInsets.only(left: 16.w, right: 16.w),
                                itemCount: _products.length,
                                itemBuilder: (context, index) => ProductCard(
                                  product: _products[index],
                                  showBrand: true,
                                ),
                                separatorBuilder: (context, index) => SizedBox(width: 20.w),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '업사이클링 프로젝트',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            // 업사이클링 프로젝트 내용 추가
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}