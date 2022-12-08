import 'dart:math';

import 'package:firstband/entities/appliance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import '../../entities/instrument.dart';
import '../model_controller.dart';
import 'appliance_track.dart';

class ApplianceTracksController extends GetxController {
  final List<Appliance> appliances;
  final scrollControllers = LinkedScrollControllerGroup();

  ApplianceTracksController(this.appliances);

  final tracks = <ApplianceTrack>[].obs;

  @override
  void onInit() {
    final modelController = Get.find<ModelController>();
    modelController.project.listen((project) {
      appliances.clear();
      appliances.addAll(project.appliances);

      for (var appliance in appliances) {
        for (var instrument in appliance.instruments) {
          addTrack(appliance: appliance, instrument: instrument);
        }
      }
    });

    super.onInit();
  }

  void addTrack({
    required Appliance appliance,
    required Instrument instrument,
  }) {
    final index = tracks.lastIndexWhere((element) =>
            element.controller.instrument.value.kind == instrument.kind) +
        1;
    final scrollController = scrollControllers.addAndGet();
    final track = ApplianceTrack(
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
    for (var appliance in appliances) {
      if (Get.find<ModelController>().addInstrument(appliance, instrument)) {
        addTrack(appliance: appliance, instrument: instrument);
      }
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

class ApplianceTrackContainer extends GetView<ApplianceTracksController> {
  ApplianceTrackContainer({required List<Appliance> appliances, super.key}) {
    Get.put(ApplianceTracksController(appliances));
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
