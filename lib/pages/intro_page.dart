import 'dart:convert';
import 'dart:typed_data';
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

  List<String> _imgs = [];

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
              color: _currentPage == index ? Colors.amber : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: PageView.builder(
          controller: _pageController,
          itemCount: _imgs.length,
          onPageChanged: (index){
            setState(() {
              _currentPage = index;
            });
          },
          itemBuilder: (context, index){
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(_imgs[index]),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut
                      );
                    },
                    child: const Text('다음')),

                ],
              ),
            );
          }
      ),
      bottomNavigationBar: _buildIndicator(),
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