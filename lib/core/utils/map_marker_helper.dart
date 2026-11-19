import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerHelper {
  
  /// Compact driver navigation cursor (size 56x56 px instead of 110px)
  static Future<BitmapDescriptor> createDriverCarMarkerBitmap() async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 56.0;
    const double radius = size / 2;
    
    // Inner vehicle circle
    final Paint bodyPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..isAntiAlias = true;
    canvas.drawCircle(const Offset(radius, radius), radius - 8, bodyPaint);

    // Lime accent border
    final Paint borderPaint = Paint()
      ..color = const Color(0xFFC7F435)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..isAntiAlias = true;
    canvas.drawCircle(const Offset(radius, radius), radius - 8, borderPaint);

    // Direction arrow
    final Paint arrowPaint = Paint()
      ..color = const Color(0xFFC7F435)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final Path arrowPath = Path();
    arrowPath.moveTo(radius, radius - 9);
    arrowPath.lineTo(radius + 7, radius + 7);
    arrowPath.lineTo(radius, radius + 3);
    arrowPath.lineTo(radius - 7, radius + 7);
    arrowPath.close();

    canvas.drawPath(arrowPath, arrowPaint);

    final ui.Image image = await pictureRecorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.bytes(byteData!.buffer.asUint8List());
  }
}
