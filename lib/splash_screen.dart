import 'package:flutter/material.dart';
// 这是开屏动画
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // 启动渐显动画
    Future.delayed(Duration.zero, () {
      setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: _opacity,
        child: Center(
          child: Image.asset('assets/ic_launcher.png', width: 150),
        ),
      ),
    );
  }
}


/* 
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(), // 直接使用独立组件
      routes: {
        '/home': (context) => HomeScreen(), // 后续跳转主页
      },
    );
  }
}



   */