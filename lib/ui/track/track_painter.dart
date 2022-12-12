import 'package:firstband/entities/appliance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entities/instrument.dart';
import '../model_controller.dart';

class TrackPainter extends CustomPainter {
  Appliance appliance;
  Instrument instrument;
  final List<Offset> offsets = [];
  final rectWidth = 5.0;
  Color color = const Color.fromARGB(0xFF, 0x7E, 0x2B, 0x70);

  TrackPainter(this.appliance, this.instrument) {
    final model = Get.find<ModelController>();
    calculateOffset(model.totalPlayTimeInMilliSec, model.trackWidth);
    model.project.listen((project) {
      final newAppliance =
          project.appliances.firstWhereOrNull((e) => e.name == appliance.name);

      final newInstrument = newAppliance?.instruments
          .firstWhereOrNull((e) => e.kind == instrument.kind);

      if (newAppliance != null && newInstrument != null) {
        appliance = newAppliance;
        instrument = newInstrument;
        calculateOffset(model.totalPlayTimeInMilliSec, model.trackWidth);
      }
    });
  }

  void calculateOffset(double totalMilliSec, double trackWidth) {
    color = appliance.name.contains('Washer1')
        ? const Color.fromARGB(0xFF, 0x7E, 0x2B, 0x70)
        : const Color.fromARGB(0xFF, 0x3E, 0x50, 0x6B);

    offsets.clear();
    for (var bit in instrument.bits) {
      // width : total = x : msec
      final msec = bit.msec.toDouble();
      final xOffset = trackWidth * msec / totalMilliSec;
      offsets.add(Offset(xOffset, bit.value?.toDouble() ?? 0.0));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = rectWidth;

    // offset : 44 = x : height
    final yOffset = size.height / 2;
    final newHeight = size.height / 2;
    for (var offset in offsets) {
      final dy = (offset.dy * newHeight / 45) - newHeight;
      final newOffset = Offset(offset.dx, dy);

      // Rect rect = Rect.fromCenter(
      //   center: newOffset,
      //   width: rectWidth,
      //   height: rectWidth,
      // );
      // canvas.drawRect(rect, paint);

      canvas.drawCircle(newOffset, rectWidth, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TrackPainter oldDelegate) {
    return false;
  }
}
