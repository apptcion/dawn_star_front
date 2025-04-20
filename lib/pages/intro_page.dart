import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget{
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreen();
}

class _IntroScreen extends State<IntroScreen>{
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<String> _imgs = [
    'assets/tutorial_2.png',
    'assets/tutorial_3.png',
    'assets/tutorial_4.png',
    'assets/tutorial_5.png'
  ];

  final List<RichText> _texts = [
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '검증된 기부단체들\n',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 27.w,
              height: 1.5
          ),
          children: [
            TextSpan(
              text: '일반 브랜드 구매 시',
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 20.w
              )
            )
          ]
      ),
    ),
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '다양한 환경 브랜드\n상품들을 모아서',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 27.w
          )
      ),
    ),
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '집에서 쉽게 하는\n나만의 업사이클링',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 27.w
          )
      ),
    ),
    RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: '당신만의 ',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 27.w,
              height: 1.5
          ),
          children: [
            TextSpan(
                text: '가치소비 ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFF9A00),
                    fontSize: 27.w
                )
            ),
            TextSpan(
                text: '라이프를\n',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27.w
                )
            ),
            TextSpan(
                text: '실천해 보세요',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 27.w
                )
            )
          ]
      ),
    ),
  ];

  Widget _buildIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _imgs.length,
              (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentPage == index ? Color(0xffFFC123) : Color(0xffD9D9D9),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 🖼 이미지 고정
            SizedBox(
              height: 650.h, // 원하는 고정 높이로 조절
              child: PageView.builder(
                controller: _pageController,
                itemCount: _imgs.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 500.h,
                          child: Image.asset(
                            _imgs[index],
                            scale: 0.85
                          ),
                        ),
                        _texts[index]
                      ]
                    ),
                  );
                },
              ),
            ),
            /// 🔘 인디케이터 + 버튼
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                children: [
                  _buildIndicator(),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _imgs.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        // 예: 튜토리얼 끝났을 때 처리
                        Navigator.pushReplacementNamed(context, '/home_page');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.white,
                      minimumSize: Size(double.infinity, 48.h),
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // 살짝만 둥글게
                      ),
                    ),
                    child: Text('다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.w
                      )),
                  ),
                  SizedBox(height: 10.h)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IntroPage extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IntroScreen()
    );
  }
}