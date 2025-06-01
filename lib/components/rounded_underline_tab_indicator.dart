import 'package:flutter/material.dart';

class RoundedUnderlineTabIndicator extends Decoration {
  final BorderSide borderSide;
  final EdgeInsetsGeometry insets;
  final double radius;
  final double width;

  const RoundedUnderlineTabIndicator({
    this.borderSide = const BorderSide(width: 2.0, color: Colors.orange),
    this.insets = EdgeInsets.zero,
    this.radius = 4.0,
    this.width = 25,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _RoundedUnderlinePainter(this, onChanged);
  }
}

class _RoundedUnderlinePainter extends BoxPainter {
  final RoundedUnderlineTabIndicator decoration;

  _RoundedUnderlinePainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    final indicator = decoration.insets.resolve(TextDirection.ltr).deflateRect(rect);
    
    final paint = Paint()
      ..color = decoration.borderSide.color
      ..style = PaintingStyle.fill;
    
    // Calculate centered position with custom width
    final xPos = indicator.left + (indicator.width - decoration.width) / 2;
    final yPos = indicator.bottom - decoration.borderSide.width;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          xPos,
          yPos,
          decoration.width,
          decoration.borderSide.width,
        ),
        Radius.circular(decoration.radius),
      ),
      paint,
    );
  }
}
