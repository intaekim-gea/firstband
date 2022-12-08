import 'dart:convert';

import 'package:firstband/ui/appliance/appliance_tracks.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../entities/project.dart';
import 'communications/communication_controller.dart';
import 'model_controller.dart';
import 'music_page.dart';
import 'piano/piano_controller.dart';
import 'piano/piano_widget.dart';
import 'track/track_container.dart';

const kLeft = 'D8:28:C9:13:BA:E5';
const kRight = 'D8:28:C9:34:2E:16';
// const kRight = 'D8:28:C9:13:BA:E5';
// const kLeft = 'D8:28:C9:34:2E:16';

class MainPageController extends GetxController {
  final trackContainers = <TrackContainer>[].obs;
  final selectedBeanTag = kLeft.obs;

  @override
  void onInit() async {
    super.onInit();
    final model = Get.find<ModelController>();
    model.project.listen((p0) {
      updateTrackContainers();
    });
    final newProject = await loadProject();
    Get.find<ModelController>().setProject(newProject);
  }

  Future<Project> loadProject() async {
    final string = await rootBundle.loadString('assets/alliwant.json');
    final json = jsonDecode(string);
    final project = Project.fromJson(json);
    return project;
  }

  void updateTrackContainers() {
    final newTrackContainers = <TrackContainer>[];
    final model = Get.find<ModelController>();
    for (var appliance in model.project.value.appliances) {
      newTrackContainers.add(TrackContainer(appliance: appliance));
      break;
    }
    trackContainers.clear();
    trackContainers.addAll(newTrackContainers);
  }
}

class MainPage extends GetView<MainPageController> {
  static const String name = '/main';

  CommunicationController get left => Get.find(tag: kLeft);
  CommunicationController get right => Get.find(tag: kRight);

  MainPage({super.key}) {
    Get.put(CommunicationController(kLeft), tag: kLeft);
    Get.put(CommunicationController(kRight), tag: kRight);
    Get.put(PianoController(kLeft), tag: kLeft);
    Get.put(PianoController(kRight), tag: kRight);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () => Get.find<ModelController>().play(),
            child: const Text(
              'Play',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: () {
                left.tryToConnect();
                right.tryToConnect();
              },
              color: left.isConnected.value && right.isConnected.value
                  ? Colors.greenAccent
                  : Colors.redAccent,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
          TextButton(
            onPressed: () => Get.toNamed(MusicPage.name),
            child: const Text(
              'Music',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(0xFF, 0x2A, 0x2A, 0x2A),
        child: Obx(
          () {
            final model = Get.find<ModelController>();
            return Column(
              children: [
                ApplianceTrackContainer(
                  appliances: model.project.value.appliances,
                ),
                SizedBox(
                  height: 250,
                  child: PianoWidget(
                    beanTag: controller.selectedBeanTag.value,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
