import 'dart:convert';
import 'dart:typed_data';

import 'package:daystar/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'upcycling_page.dart';
import 'my_page.dart';
import '../widgets/banner_widget.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/brand_filter_chip.dart';
import '../config.dart';

//안녕하세요
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const UpcyclingPage(),
    const MyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Color(0xFF333333),
        unselectedItemColor: Color(0xFFCCCCCC),
        selectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.recycling), label: 'UPCYCLING'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'MY PAGE'),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 22.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40.h,
                        padding: EdgeInsets.only(left: 11.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '키워드를 입력해 보세요.',
                              hintStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, color: Colors.grey),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 18.w),
                    SizedBox(
                      width: 25.w,
                      height: 25.h,
                      child: const Icon(Icons.notifications_none),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 57.h,
                child: TabBar(
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w400),
                  tabs: const [
                    Tab(text: '환경 브랜드'),
                    Tab(text: '일반 브랜드'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    BrandTab(type: 'eco'),
                    BrandTab(type: 'normal'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandTab extends StatefulWidget{
  final String type;
  const BrandTab({super.key, required this.type});

  @override
  State<BrandTab> createState() => _BrandTabState();
}

class _BrandTabState extends State<BrandTab>{
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerWidget(type: widget.type),
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 19.h, bottom: 18.h),
            child: Text(
              '최우주님을 위한 추천 상품',
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 280.h,
            child: FutureBuilder<List<Product>>(
              future: fetchProducts(widget.type),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('오류 발생: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('상품이 없습니다.'));
                }

                // 데이터를 평탄화
                final products = snapshot.data!;

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: products.length,
                  itemBuilder: (context, index) => ProductCard(product: products[index]),
                  separatorBuilder: (context, index) => SizedBox(width: 20.w),
                );
              },
            ),
          ),
          BrandProduct(type: widget.type)
        ],
      ),
    );
  }
}

Future<List<Product>> fetchProducts(String type) async{
  final response = await http.get(
      Uri.parse('${appConfig.apiUrl}/product/getALL?type=${type}'));
  if (response.statusCode == 200){
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Product.fromJSON(json)).toList();
  } else{
    throw Exception("failed to load Products");
  }
}

class BrandProduct extends StatefulWidget{
  final String type;
  const BrandProduct({super.key, required this.type});

  @override
  State<BrandProduct> createState() => _BrandProductState();
}

class _BrandProductState extends State<BrandProduct> {

  String _selectedBrand = 'All';
  List<Brand> _brands = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchBrands(widget.type);
  }

  Future<void> _fetchBrands(String type) async {
    try {
      final response = await http.get(
          Uri.parse('${appConfig.apiUrl}/brand/getALL?getProd=true&type=${type}'));
      if (response.statusCode == 200) {
        List<dynamic> brand = jsonDecode(response.body);
        final brands = brand.map((e) => Brand.fromJSON(e)).toList();

        setState(() {
          _brands = brands;
          _isLoading = false;
        });
      } else {
        throw Exception('failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _changeSelectedBrand(String brandName){
    setState(() {
      _selectedBrand = brandName;
    });
  }

  Widget _buildBrandSection(String brand, Uint8List LogoImg, List<Product> products, void Function(String) changeSelctedBrand) {
    return Column(
      children: [
        GestureDetector(
          onTap: (){
            changeSelctedBrand(brand);
          },
          child: Container(
            width: 362.w,
            height: 142.h,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Image.memory(
                LogoImg,
                fit: BoxFit.cover
            ),
          )
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: products.length != 0 ? 260.h : 100.h,
          child:
              products.length != 0 ?
            ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: products.length,
              padding: EdgeInsets.only(right: 16.w),
              itemBuilder: (context, index){
                return ProductCard(product: products[index], showBrand: false);
              },
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
            ) :
              Center(child: Text('상품이 없습니다.'))
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, top: 23.h, bottom: 18.h),
            child: Text(
              widget.type == 'eco' ?
                '환경 브랜드 상품' : '일반 브랜드 상품',
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 33.h,
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: BrandFilterSection(
                brands: ['All', ... _brands.map((brand) => brand.name).toList()],
                selectedBrand: _selectedBrand,
                onBrandSelected: (brand) {
                  setState(() {
                    _selectedBrand = brand;
                  });
                },
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),
          _isLoading ? Center(child: CircularProgressIndicator()) :
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _selectedBrand == 'All'
                ? Column(
                children: _brands.map((brand) =>
                   _buildBrandSection(
                     brand.name,
                     brand.brandImg,
                     brand.products as List<Product>,
                     _changeSelectedBrand
                   )
                ).toList()
              ) : _buildBrandSection(_selectedBrand,
                  _brands.firstWhere((brand) => brand.name == _selectedBrand).brandImg,
                  _brands.firstWhere((brand) => brand.name == _selectedBrand).products as List<Product>,
                  _changeSelectedBrand)
            )
      ],
    );
  }
}

class BrandFilterSection extends StatefulWidget {
  final List<String> brands;
  final Function(String) onBrandSelected;
  final String selectedBrand;

  const BrandFilterSection({
    super.key, 
    required this.brands,
    required this.onBrandSelected,
    required this.selectedBrand
  });

  @override
  State<BrandFilterSection> createState() => _BrandFilterSectionState();
}

class _BrandFilterSectionState extends State<BrandFilterSection> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        widget.brands.length,
        (index) {
          return Padding(
            padding: EdgeInsets.only(right: 9.w),
            child: BrandFilterChip(
              label: widget.brands[index],
              isSelected: widget.selectedBrand == widget.brands[index],
              onSelected: () {
                widget.onBrandSelected(widget.brands[index]);
              },
            ),
          );
        },
      ),
    );
  }
}