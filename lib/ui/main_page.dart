import 'package:firstband/ui/music_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          TextButton(
            onPressed: () => Get.toNamed(MusicPage.name),
            child: const Text(
              'Music',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: const PianoWidget(),
    );
  }
}
