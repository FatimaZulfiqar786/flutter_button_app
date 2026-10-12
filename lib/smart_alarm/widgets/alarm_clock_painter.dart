import 'dart:math' as math;
import 'package:flutter/material.dart';

class AlarmClockIllustration extends StatelessWidget {
  final double size;
  final Color color;

  const AlarmClockIllustration({
    super.key,
    this.size = 110,
    this.color = const Color(0xFFFF5268),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _AlarmClockPainter(color: color),
    );
  }
}

class _AlarmClockPainter extends CustomPainter {
  final Color color;

  _AlarmClockPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h * 0.52);
    final radius = w * 0.36;

    final paintStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final paintLightStroke = Paint()
      ..color = color.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 1. Two top bells (retro twin bells)
    final leftBellAngle = -math.pi * 0.72;
    final rightBellAngle = -math.pi * 0.28;

    _drawBell(canvas, center, radius + 4, leftBellAngle, paintStroke);
    _drawBell(canvas, center, radius + 4, rightBellAngle, paintStroke);

    // 2. Bell striker/handle on top center
    final handleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - radius - 10),
      width: 14,
      height: 8,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(handleRect, const Radius.circular(4)),
      paintStroke,
    );

    // 3. Two bottom angled feet
    final leftFootStart = Offset(center.dx - radius * 0.65, center.dy + radius * 0.75);
    final leftFootEnd = Offset(center.dx - radius * 0.90, center.dy + radius + 12);
    canvas.drawLine(leftFootStart, leftFootEnd, paintStroke);

    final rightFootStart = Offset(center.dx + radius * 0.65, center.dy + radius * 0.75);
    final rightFootEnd = Offset(center.dx + radius * 0.90, center.dy + radius + 12);
    canvas.drawLine(rightFootStart, rightFootEnd, paintStroke);

    // 4. Main Clock Body (outer circle)
    canvas.drawCircle(center, radius, paintStroke);

    // Inner concentric circle (light accent)
    canvas.drawCircle(center, radius * 0.85, paintLightStroke);

    // 5. Hour and minute hands pointing to 7:20
    // Center pivot dot
    canvas.drawCircle(center, 4, paintFill);

    // Hour hand pointing towards 7 (around 125 degrees from top / 215 deg)
    // In clock coords: 7 o'clock is 210 degrees clockwise from 12 o'clock (or -150 deg)
    const hourHandAngle = (7 + 20 / 60) * 30 * (math.pi / 180) - math.pi / 2;
    final hourHandEnd = Offset(
      center.dx + math.cos(hourHandAngle) * (radius * 0.48),
      center.dy + math.sin(hourHandAngle) * (radius * 0.48),
    );
    final hourPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, hourHandEnd, hourPaint);

    // Minute hand pointing towards 20 minutes (4 o'clock / 120 degrees clockwise from 12)
    const minHandAngle = 20 * 6 * (math.pi / 180) - math.pi / 2;
    final minHandEnd = Offset(
      center.dx + math.cos(minHandAngle) * (radius * 0.68),
      center.dy + math.sin(minHandAngle) * (radius * 0.68),
    );
    final minPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(center, minHandEnd, minPaint);

    // Accent dot at bottom dial as seen in the mockup
    final accentDotOffset = Offset(center.dx, center.dy + radius * 0.55);
    final accentDotPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(accentDotOffset, 2.8, accentDotPaint);
  }

  void _drawBell(
    Canvas canvas,
    Offset center,
    double distance,
    double angle,
    Paint paint,
  ) {
    final bellCenter = Offset(
      center.dx + math.cos(angle) * distance,
      center.dy + math.sin(angle) * distance,
    );

    canvas.save();
    canvas.translate(bellCenter.dx, bellCenter.dy);
    canvas.rotate(angle + math.pi / 2);

    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: 24,
      height: 14,
    );
    canvas.drawArc(rect, math.pi, math.pi, false, paint);
    canvas.drawLine(Offset(-12, 0), Offset(12, 0), paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
