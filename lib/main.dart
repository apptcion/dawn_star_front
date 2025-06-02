import 'package:daystar/config.dart';
import 'package:daystar/pages/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/home_page.dart';

void main(){
  const bool useAPIServer = true;
  appConfig = AppConfig(
    apiUrl: useAPIServer
        ? 'https://api.xn--bm3bv8e.com'
        : 'http://10.0.2.2:3000'
  );

 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _isFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun') ?? true;
    if(isFirstRun){
      await prefs.setBool('isFirstRun', false);
    }
    return isFirstRun;
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return FutureBuilder(
          future: _isFirstRun(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator())
                )
              );
            }

            return MaterialApp(
              routes: {
                '/home_page' :(context) => HomePage()
              },
              title: 'Upcycling App',
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  backgroundColor: Colors.white,
                ),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Colors.white,
                ),
                scaffoldBackgroundColor: Colors.white,
                primarySwatch: Colors.green,
              ),
              home: snapshot.data! ? IntroPage() : HomePage()
            );
          }
        );
      },
    );
  }
}
