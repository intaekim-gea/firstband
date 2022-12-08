import 'package:firstband/entities/appliance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entities/instrument.dart';
import '../model_controller.dart';

class TrackPainter extends CustomPainter {
  Appliance appliance;
  Instrument instrument;
  final List<double> offsets = [];
  final rectWidth = 5.0;

  TrackPainter(this.appliance, this.instrument) {
    final model = Get.find<ModelController>();
    calculateOffset(model.totalPlayTimeInMilliSec, model.trackWidth);
    model.project.listen((project) {
      final newInstrument = project.appliances
          .firstWhereOrNull((e) => e.name == appliance.name)
          ?.instruments
          .firstWhereOrNull((e) => e.kind == instrument.kind);

      if (newInstrument != null) {
        instrument = newInstrument;
        calculateOffset(model.totalPlayTimeInMilliSec, model.trackWidth);
      }
    });
  }

  void calculateOffset(double totalMilliSec, double trackWidth) {
    offsets.clear();
    for (var bit in instrument.bits) {
      // width : total = x : msec
      final msec = bit.msec.toDouble();
      final xOffset = trackWidth * msec / totalMilliSec;
      offsets.add(xOffset);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = rectWidth;

    final yOffset = size.height / 2;
    for (var offset in offsets) {
      Rect rect = Rect.fromCenter(
        center: Offset(offset, yOffset),
        width: rectWidth,
        height: size.height / 3,
      );
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TrackPainter oldDelegate) {
    return false;
  }
}
