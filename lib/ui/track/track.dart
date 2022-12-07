import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entities/instrument.dart';
import '../model_controller.dart';
import 'track_painter.dart';

class TrackController extends GetxController {
  final instrument = Instrument(kind: KindOfInstrument.none, bits: []).obs;
  final ScrollController scrollController;

  final trackSize = Size(Get.find<ModelController>().trackWidth, 120).obs;

  TrackController({
    required Instrument aInstrument,
    required this.scrollController,
  }) {
    instrument.value = aInstrument;
  }
}

class Track extends GetView<TrackController> {
  final int index;
  final String _tag;
  @override
  String get tag => _tag;

  Track({
    required Instrument instrument,
    required ScrollController scrollController,
    this.index = 0,
    super.key,
  }) : _tag = '${instrument.kind.value}$index' {
    Get.put(
        TrackController(
          aInstrument: instrument,
          scrollController: scrollController,
        ),
        tag: _tag);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(Random().nextInt(0xFFFFFF) + 0xFF000000),
              Color(Random().nextInt(0xFFFFFF) + 0xFF000000),
            ],
          ),
        ),
        child: SizedBox(
          width: controller.trackSize.value.width,
          height: controller.trackSize.value.height,
          child: GestureDetector(
            onTapUp: (details) {
              print(details.localPosition);
            },
            child: CustomPaint(
              painter: TrackPainter(controller.instrument.value),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: _rulers(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _rulers() {
    final rulers = <Widget>[];
    final size = controller.trackSize.value;
    const bigInterval = ModelController.intervalPerSec / 2;
    const tickness = 2.0;
    var start = 0.0;
    while (start < size.width - tickness) {
      const bigIndicatorWidget = SizedBox(
        width: tickness,
        height: 20,
        child: ColoredBox(color: Colors.blueGrey),
      );
      start += tickness;
      rulers.add(bigIndicatorWidget);

      final interval = min(size.width - start, bigInterval);
      final intervalWidget = SizedBox(
        width: interval,
      );
      start += interval;
      rulers.add(intervalWidget);
    }
    return rulers;
  }
}
