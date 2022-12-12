import 'dart:math';

import 'package:firstband/ui/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../entities/appliance.dart';
import '../../entities/instrument.dart';
import '../model_controller.dart';
import '../track/track_painter.dart';

class ApplianceTrackController extends GetxController {
  final appliance = Appliance(name: '', instruments: [], beanMac: kRight).obs;
  final instrument = Instrument(kind: KindOfInstrument.none, bits: []).obs;
  final ScrollController scrollController;

  final trackSize = Size(Get.find<ModelController>().trackWidth, 80).obs;

  ApplianceTrackController({
    required Appliance aAppliance,
    required Instrument aInstrument,
    required this.scrollController,
  }) {
    appliance.value = aAppliance;
    instrument.value = aInstrument;
  }
}

class ApplianceTrack extends GetView<ApplianceTrackController> {
  final int index;
  final String _tag;
  @override
  String get tag => _tag;

  ApplianceTrack({
    required Appliance appliance,
    required Instrument instrument,
    required ScrollController scrollController,
    this.index = 0,
    super.key,
  }) : _tag = '${instrument.kind.value}$index' {
    Get.put(
        ApplianceTrackController(
          aAppliance: appliance,
          aInstrument: instrument,
          scrollController: scrollController,
        ),
        tag: _tag);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ColoredBox(
        color: const Color.fromARGB(0xFF, 0x19, 0x19, 0x19),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              iconSize: 80,
              icon: controller.appliance.value.name.contains('Washer1')
                  ? Image.asset('assets/layer-6-copy@3x.png')
                  : Image.asset('assets/layer-5-copy@3x.png'),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: controller.trackSize.value.width,
                  height: controller.trackSize.value.height,
                  child: GestureDetector(
                    onTapUp: (details) {
                      print(details.localPosition);
                    },
                    child: CustomPaint(
                      painter: TrackPainter(
                        controller.appliance.value,
                        controller.instrument.value,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: _rulers(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
