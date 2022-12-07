import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'track/track_container.dart';

class TrackPageController extends GetxController {
  TrackPageController();

  @override
  void onInit() {
    Get.put(
      TrackContainerController(),
    );
    super.onInit();
  }
}

class TrackPage extends GetView<TrackPageController> {
  static const name = '/track';
  const TrackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: TrackContainer(),
      ),
    );
  }
}
