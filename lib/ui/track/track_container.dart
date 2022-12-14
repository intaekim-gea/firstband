import 'dart:math';

import 'package:firstband/entities/appliance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../entities/instrument.dart';
import '../model_controller.dart';
import 'track.dart';

class TrackContainerController extends GetxController {
  final Appliance appliance;
  final scrollControllers = LinkedScrollControllerGroup();

  TrackContainerController(this.appliance);

  final tracks = <Track>[].obs;

  @override
  void onInit() {
    for (var instrument in appliance.instruments) {
      addTrack(instrument: instrument);
    }
    super.onInit();
  }

  void addTrack({required Instrument instrument}) {
    final index = tracks.lastIndexWhere((element) =>
            element.controller.instrument.value.kind == instrument.kind) +
        1;
    final scrollController = scrollControllers.addAndGet();
    final track = Track(
      appliance: appliance,
      instrument: instrument,
      scrollController: scrollController,
      index: index,
      key: GlobalKey(),
    );
    tracks.add(track);
  }

  void addNewTrack() {
    final kinds = {
      0: KindOfInstrument.buzz,
      1: KindOfInstrument.drainPump,
      2: KindOfInstrument.lidLock,
    };
    final kind = kinds[tracks.length]!;
    final instrument = Instrument(kind: kind, bits: []);
    if (Get.find<ModelController>().addInstrument(appliance, instrument)) {
      addTrack(instrument: instrument);
    }
  }

  void play() {
    if (tracks.isNotEmpty) {
      // effectiveWidth : totalSec = remainWidth : x
      final firstWidget = tracks.first;
      final scrollContentWidth = firstWidget.controller.trackSize.value.width;
      final widgetWidth =
          (firstWidget.key! as GlobalKey).currentContext!.size!.width;
      final effectiveWidth = max(scrollContentWidth - widgetWidth, 1.0);

      final modelController = Get.find<ModelController>();
      final durationInMilliSec = (modelController.totalPlayTimeInMilliSec *
              (modelController.trackWidth - scrollControllers.offset)) /
          modelController.trackWidth;

      scrollControllers.animateTo(
        modelController.trackWidth,
        curve: Curves.linear,
        duration: Duration(milliseconds: durationInMilliSec.toInt()),
      );
    }
  }
}

class TrackContainer extends GetView<TrackContainerController> {
  final String _tag;
  @override
  String get tag => _tag;

  TrackContainer({required Appliance appliance, super.key})
      : _tag = appliance.name {
    Get.put(TrackContainerController(appliance), tag: _tag);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.tracks,
                if (controller.tracks.length < Appliance.maxTrackCount)
                  IconButton(
                    onPressed: controller.addNewTrack,
                    icon: const Icon(Icons.add_box),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
