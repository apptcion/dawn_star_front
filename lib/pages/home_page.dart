import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'upcycling_page.dart';
import 'my_page.dart';
import '../widgets/banner_widget.dart';
import '../widgets/general_banner_widget.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/brand_filter_chip.dart';

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

class EcoBrandTab extends StatefulWidget {
  const EcoBrandTab({super.key});

  @override
  State<EcoBrandTab> createState() => _EcoBrandTabState();
}

class _EcoBrandTabState extends State<EcoBrandTab> {
  String _selectedBrand = 'All';

  final Map<String, List<Product>> _brandProducts = {
    'EARTH, US': [
      Product(
        id: 'earth_1',
        name: '나만의 업사이클링 키링',
        brand: 'EARTH, US',
        price: '12,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
      Product(
        id: 'earth_2',
        name: '나만의 어스톡',
        brand: 'EARTH, US',
        price: '15,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
    ],
    'UPMOST': [
      Product(
        id: 'upmost_1',
        name: '업모스트 에코백',
        brand: 'UPMOST',
        price: '35,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
      Product(
        id: 'upmost_2',
        name: '업모스트 텀블러',
        brand: 'UPMOST',
        price: '28,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
    ],
    'REBORN': [
      Product(
        id: 'reborn_1',
        name: '리본 패브릭 가방',
        brand: 'REBORN',
        price: '55,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
      Product(
        id: 'reborn_2',
        name: '리본 에코 파우치',
        brand: 'REBORN',
        price: '23,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
    ],
    'Glück': [
      Product(
        id: 'gluck_1',
        name: '글륵 리사이클 팔찌',
        brand: 'Glück',
        price: '18,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
      Product(
        id: 'gluck_2',
        name: '글륵 에코 목걸이',
        brand: 'Glück',
        price: '22,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'eco',
      ),
    ],
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
              '환경 브랜드 상품',
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
                  brands: const ['All', 'EARTH, US', 'UPMOST', 'REBORN', 'Glück'],
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

class BrandFilterSection extends StatefulWidget {
  final List<String> brands;
  final Function(String) onBrandSelected;
  
  const BrandFilterSection({
    super.key, 
    required this.brands,
    required this.onBrandSelected,
  });

  @override
  State<BrandFilterSection> createState() => _BrandFilterSectionState();
}

class _BrandFilterSectionState extends State<BrandFilterSection> {
  int _selectedIndex = 0;

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
              isSelected: _selectedIndex == index,
              onSelected: () {
                setState(() {
                  _selectedIndex = index;
                });
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
        price: '45,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
      Product(
        id: 'earth_4',
        name: '어스어스 키체인',
        brand: 'EARTH, US',
        price: '15,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
    ],
    'UPMOST': [
      Product(
        id: 'upmost_1',
        name: 'AirPods Pro Case [ White Blue ]',
        brand: 'UPMOST',
        price: '25,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
      Product(
        id: 'upmost_2',
        name: 'OFF WHITE [PINK]',
        brand: 'UPMOST',
        price: '113,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
    ],
    'REBORN': [
      Product(
        id: 'reborn_3',
        name: '리본 데님 백팩',
        brand: 'REBORN',
        price: '89,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
      Product(
        id: 'reborn_4',
        name: '리본 미니백',
        brand: 'REBORN',
        price: '67,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
    ],
    'Romang Story': [
      Product(
        id: 'romang_1',
        name: '로망 스토리 숄더백',
        brand: 'Romang Story',
        price: '78,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
      Product(
        id: 'romang_2',
        name: '로망 스토리 클러치',
        brand: 'Romang Story',
        price: '45,000',
        imageUrl: 'https://via.placeholder.com/170',
        category: 'general',
      ),
    ],
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