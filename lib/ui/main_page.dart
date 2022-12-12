import 'dart:async';
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
  final title = ''.obs;
  final String filePath;
  final trackContainers = <TrackContainer>[].obs;
  final selectedBeanTag = kLeft.obs;
  StreamSubscription? _subscription;

  MainPageController(this.filePath);

  @override
  void onInit() async {
    super.onInit();
    final model = Get.find<ModelController>();
    _subscription = model.project.listen((p0) {
      title.value = p0.name;
      updateTrackContainers();
    });
    final newProject = await loadProject();
    Get.find<ModelController>().setProject(newProject);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  Future<Project> loadProject() async {
    if (filePath.isNotEmpty) {
      try {
        final string = await rootBundle.loadString(filePath);
        final json = jsonDecode(string);
        final project = Project.fromJson(json);
        return project;
      } catch (e) {
        printError(info: '$e');
      }
    }
    return Project(name: 'Untitled', appliances: []);
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
  static const leftRightPadding = 30.0;

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
    return WillPopScope(
      onWillPop: () async {
        Get.find<ModelController>().stop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color.fromARGB(0xFF, 0x2A, 0x2A, 0x2A),
          title: Obx(() => Text(controller.title.value)),
          actions: [
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
            // TextButton(
            //   onPressed: () => Get.toNamed(MusicPage.name),
            //   child: const Text(
            //     'Music',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
        body: Container(
          color: const Color.fromARGB(0xFF, 0x2A, 0x2A, 0x2A),
          child: Obx(
            () {
              final model = Get.find<ModelController>();
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: leftRightPadding,
                        right: leftRightPadding,
                      ),
                      child: ApplianceTrackContainer(
                        appliances: model.project.value.appliances,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: leftRightPadding,
                      right: leftRightPadding,
                    ),
                    child: SizedBox(
                      height: 130,
                      child: Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 250,
                              height: 300,
                              child: Image.asset(
                                'assets/rounded-rectangle-2@3x.png',
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final comm =
                                        Get.find<CommunicationController>(
                                      tag: kLeft,
                                    );
                                    comm.playDrainPump();
                                    // Get.find<ModelController>().stop();
                                    // Get.back();
                                  },
                                  icon: Image.asset('assets/layer-19@3x.png'),
                                ),
                              ],
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    final model = Get.find<ModelController>();
                                    model.stop();
                                  },
                                  icon: Image.asset('assets/layer-18@3x.png'),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  onPressed: () {},
                                  iconSize: 80,
                                  icon: Image.asset('assets/layer-15@3x.png'),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  onPressed: () {
                                    final model = Get.find<ModelController>();
                                    model.play();
                                  },
                                  icon: Image.asset('assets/layer-17@3x.png'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
      ),
    );
  }
}
