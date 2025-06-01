// blur_appbar.dart‘
import 'package:flutter/material.dart'; // 核心组件库
import 'dart:ui'; // BackdropFilter所需库


AppBar createBlurAppBar({
  required String title,
  double sigma = 6.0,
  double opacity = 0.25
}) {
  return AppBar(
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(color: Colors.white.withOpacity(opacity)),
      ),
    ),
    title: Text(title),
  );
}



