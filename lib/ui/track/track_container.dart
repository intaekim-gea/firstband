import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../entities/instrument.dart';
import '../../entities/project.dart';
import '../model_controller.dart';
import 'track.dart';

class TrackContainerController extends GetxController {
  Project get project => Get.find<ModelController>().project.value;
  final _scrollControllers = LinkedScrollControllerGroup();

  TrackContainerController();

  final tracks = <Track>[].obs;

  @override
  void onInit() {
    for (var instrument in project.instruments) {
      addTrack(instrument: instrument);
    }
    super.onInit();
  }

  void addTrack({required Instrument instrument}) {
    final index = tracks.lastIndexWhere((element) =>
            element.controller.instrument.value.kind == instrument.kind) +
        1;
    final scrollController = _scrollControllers.addAndGet();
    final track = Track(
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
    if (Get.find<ModelController>().addInstrument(instrument)) {
      addTrack(instrument: instrument);
    }
  }

  void play() {
    if (tracks.isNotEmpty) {
      final modelController = Get.find<ModelController>();
      final firstWidget = tracks.first;
      final scrollContentWidth = firstWidget.controller.trackSize.value.width;
      final widgetWidth =
          (firstWidget.key! as GlobalKey).currentContext!.size!.width;
      final effectiveWidth = max(scrollContentWidth - widgetWidth, 1.0);

      // effectiveWidth : totalSec = remainWidth : x
      final durationInMilliSec = (modelController.totalPlayTimeInMilliSec *
              (effectiveWidth - _scrollControllers.offset)) /
          effectiveWidth;
      _scrollControllers.animateTo(
        effectiveWidth,
        curve: Curves.linear,
        duration: Duration(milliseconds: durationInMilliSec.toInt()),
      );
    }
  }
}

class TrackContainer extends GetView<TrackContainerController> {
  const TrackContainer({super.key});

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
                if (controller.tracks.length < Project.maxTrackCount)
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
