import 'dart:convert';
import 'dart:typed_data';

import 'package:daystar/models/brand_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'upcycling_page.dart';
import 'my_page.dart';
import '../widgets/banner_widget.dart';
import '../widgets/general_banner_widget.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/brand_filter_chip.dart';
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
                    EcoBrandTab(),
                    GeneralBrandTab(),
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

// class BrandTab extends StatefulWidget{
//   const BrandTab({super.key});
//
//   @override
//   State<BrandTab> createState() => _BrandTab();
// }
//
// class _BrandTab extends State<BrandTab>{
//
// }

Future<List<Product>> fetchProducts() async{
  final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/product/getALL'));
  if (response.statusCode == 200){
    final List<dynamic> jsonList = jsonDecode(response.body);
    return jsonList.map((json) => Product.fromJSON(json)).toList();
  } else{
    throw Exception("failed to load Products");
  }
}

class EcoBrandTab extends StatefulWidget {
  const EcoBrandTab({super.key});

  @override
  State<EcoBrandTab> createState() => _EcoBrandTabState();
}

class _EcoBrandTabState extends State<EcoBrandTab> {


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerWidget(),
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
              future: fetchProducts(),
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
          EcoBrandProduct()
        ],
      ),
    );
  }
}

class EcoBrandProduct extends StatefulWidget{
  @override
  State<EcoBrandProduct> createState() => _EcoBrandProductState();
}

class _EcoBrandProductState extends State<EcoBrandProduct> {

  String _selectedBrand = 'All';
  List<Brand> _brands = [];
  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchBrands();
    debugPrint("_brands List : " + _brands.toString());
  }

  Future<void> _fetchBrands() async {
    try {
      final response = await http.get(
          Uri.parse('http://10.0.2.2:3000/brand/getALL?getProd=true&type=eco'));
      debugPrint("Response Statue Code : " + response.statusCode.toString());
      if (response.statusCode == 200) {
        List<dynamic> brand = jsonDecode(response.body);
        final brands = brand.map((e) => Brand.fromJSON(e)).toList();

        setState(() {
          _brands = brands;
          _isLoading = false;
        });
        debugPrint('Debug Print at Fetch Func, _brand : ' + brands.toString());
      } else {
        throw Exception('failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint("Error : " + e.toString());
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
          height: 280.h,
          child:
            ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: products.length,
              padding: EdgeInsets.only(right: 16.w),
              itemBuilder: (context, index){
                return ProductCard(product: products[index], showBrand: false);
              },
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
            )
        ),
        SizedBox(height: 27.h),
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
              '환경 브랜드 상품',
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

class GeneralBrandTab extends StatelessWidget {
  const GeneralBrandTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const GeneralBrandTabContent();
  }
}

class GeneralBrandTabContent extends StatefulWidget {
  const GeneralBrandTabContent({super.key});

  @override
  State<GeneralBrandTabContent> createState() => _GeneralBrandTabContentState();
}

class _GeneralBrandTabContentState extends State<GeneralBrandTabContent> {
  String _selectedBrand = 'All';

  final Map<String, List<Product>> _brandProducts = {
    'EARTH, US': [
      Product(
        id: 'earth_3',
        name: '어스어스 캔버스백',
        brand: 'EARTH, US',
        priceNumber: 1000,
        base64Str: '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',
      )
    ]
  };

  Widget _buildBrandSection(String brand, List<Product> products) {
    return Column(
      children: [
        Container(
          width: 362.w,
          height: 142.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            ProductCard(product: products[0], showBrand: false),
            SizedBox(width: 20.w),
            if (products.length > 1)
              ProductCard(product: products[1], showBrand: false),
          ],
        ),
        SizedBox(height: 27.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GeneralBannerWidget(),
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              itemCount: _brandProducts.values.expand((products) => products).length,
              itemBuilder: (context, index) => ProductCard(
                product: _brandProducts.values.expand((products) => products).toList()[index],
              ),
              separatorBuilder: (context, index) => SizedBox(width: 20.w),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.w, top: 23.h, bottom: 18.h),
            child: Text(
              '일반 브랜드 상품',
              style: TextStyle(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            height: 33.h,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: BrandFilterSection(
                  brands: const ['All', 'EARTH, US', 'UPMOST', 'REBORN', 'Romang Story'],
                  selectedBrand: 'ALL',
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _selectedBrand == 'All'
                ? Column(
                    children: _brandProducts.entries.map((entry) {
                      return _buildBrandSection(entry.key, entry.value);
                    }).toList(),
                  )
                : Column(
                    children: [
                      Container(
                        width: 362.w,
                        height: 142.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (_brandProducts[_selectedBrand]?.isNotEmpty ?? false)
                        Row(
                          children: [
                            ProductCard(product: _brandProducts[_selectedBrand]![0], showBrand: false),
                            SizedBox(width: 20.w),
                            if (_brandProducts[_selectedBrand]!.length > 1)
                              ProductCard(product: _brandProducts[_selectedBrand]![1], showBrand: false),
                          ],
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}