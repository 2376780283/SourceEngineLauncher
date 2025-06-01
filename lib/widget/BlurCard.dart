import 'package:flutter/material.dart';
import 'dart:ui'; // 用于 BackdropFilter 和 ImageFilter

// 在 HomeScreen 类中添加模糊卡片组件
class BlurCard extends StatelessWidget {
  final Widget child;
  
  const BlurCard({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.95,
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // blur bitmap
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
