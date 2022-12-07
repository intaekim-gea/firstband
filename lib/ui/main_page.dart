import 'package:firstband/entities/instrument.dart';
import 'package:firstband/ui/model_controller.dart';
import 'package:firstband/ui/music_page.dart';
import 'package:firstband/ui/track/track_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../entities/project.dart';
import 'communications/communication_controller.dart';
import 'piano/piano_controller.dart';
import 'piano/piano_widget.dart';

const kLeft = 'D8:28:C9:13:BA:E5';
const _kRight = 'D8:28:C9:34:2E:16';

class MainPage extends StatelessWidget {
  static const String name = '/main';

  CommunicationController get left => Get.find(tag: kLeft);
  CommunicationController get right => Get.find(tag: _kRight);

  MainPage({super.key}) {
    Get.put(CommunicationController(kLeft), tag: kLeft);
    Get.put(CommunicationController(_kRight), tag: _kRight);
    Get.put(PianoController(kLeft));

    Get.find<ModelController>().project.value = Project(
      name: 'Project1',
      instruments: [],
    );
    Get.put(TrackContainerController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: () => Get.find<TrackContainerController>().play(),
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
        body: Column(
          children: const [
            TrackContainer(),
            SizedBox(height: 250, child: PianoWidget()),
          ],
        ));
  }
}
