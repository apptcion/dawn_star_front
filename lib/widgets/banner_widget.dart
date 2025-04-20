import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/banner_model.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

Future<List<BannerModel>> fetchBanners() async {
  final response = await http.get(
    Uri.parse('http://10.0.2.2:3000/manage/getBanner'),
  );
  if (response.statusCode == 200) {
    List<dynamic> bannerImgs = jsonDecode(response.body);
    return bannerImgs.map((data) => BannerModel.fromJSON(data)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class _BannerWidgetState extends State<BannerWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Future<List<BannerModel>> _bannerFuture;

  @override
  void initState() {
    super.initState();

    _bannerFuture = fetchBanners();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 261.h,
      child: FutureBuilder<List<BannerModel>>(
        future: _bannerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('오류: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('배너가 없습니다.'));
          }

          final banners = snapshot.data!;

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: banners.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Container(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Center(
                      child: Image.memory(
                        banner.imgBytes,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover, // 또는 BoxFit.fill
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    banners.length,
                        (index) => Container(
                      width: 5.w,
                      height: 5.w,
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? const Color(0xFF808080)
                            : const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}