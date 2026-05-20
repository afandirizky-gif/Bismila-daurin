import 'package:flutter/material.dart';
import '../theme.dart';

class DaurinLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final double fontSize;

  const DaurinLogo({
    super.key,
    this.size = 120,
    this.showText = true,
    this.fontSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom Drawn Recycling Leaf Logo
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DaurinLogoPainter(),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          Text(
            'DAURIN',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              color: AppTheme.primaryGreen,
              letterSpacing: 2.0,
            ),
          ),
        ],
      ],
    );
  }
}

class _DaurinLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintGreen = Paint()
      ..color = AppTheme.primaryGreen
      ..style = PaintingStyle.fill;

    final paintMint = Paint()
      ..color = AppTheme.mintGreen
      ..style = PaintingStyle.fill;

    final width = size.width;
    final height = size.height;

    // Draw left leaf shape (curved recycling leaf)
    final leafPath = Path();
    leafPath.moveTo(width * 0.5, height * 0.1);
    leafPath.quadraticBezierTo(
      width * 0.1,
      height * 0.15,
      width * 0.1,
      height * 0.5,
    );
    leafPath.quadraticBezierTo(
      width * 0.1,
      height * 0.8,
      width * 0.45,
      height * 0.85,
    );
    leafPath.quadraticBezierTo(
      width * 0.35,
      height * 0.6,
      width * 0.3,
      height * 0.4,
    );
    leafPath.quadraticBezierTo(
      width * 0.3,
      height * 0.25,
      width * 0.5,
      height * 0.1,
    );
    canvas.drawPath(leafPath, paintMint);

    // Draw leaf center vein lines
    final veinPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final veinPath = Path();
    veinPath.moveTo(width * 0.3, height * 0.7);
    veinPath.quadraticBezierTo(width * 0.22, height * 0.45, width * 0.4, height * 0.22);
    canvas.drawPath(veinPath, veinPaint);

    // Draw right recycling arrow shape
    final arrowPath = Path();
    // Starting loop
    arrowPath.moveTo(width * 0.5, height * 0.85);
    arrowPath.cubicTo(
      width * 0.85,
      height * 0.85,
      width * 0.9,
      height * 0.4,
      width * 0.7,
      height * 0.25,
    );
    // Outer border of arrow loop
    arrowPath.lineTo(width * 0.7, height * 0.1);
    // Arrow head
    arrowPath.lineTo(width * 0.95, height * 0.3);
    arrowPath.lineTo(width * 0.7, height * 0.5);
    arrowPath.lineTo(width * 0.7, height * 0.35);
    // Inner loop curve
    arrowPath.cubicTo(
      width * 0.8,
      height * 0.45,
      width * 0.75,
      height * 0.72,
      width * 0.5,
      height * 0.72,
    );
    arrowPath.close();

    canvas.drawPath(arrowPath, paintGreen);

    // Center connecting nodes for arrow
    canvas.drawCircle(
      Offset(width * 0.5, height * 0.85),
      width * 0.08,
      paintGreen,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
