import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'communications/communication_controller.dart';
import 'communications/communication_widget.dart';
import 'piano/piano_controller.dart';
import 'piano/piano_widget.dart';

class MainPage extends StatelessWidget {
  static const String name = '/main';

  MainPage({super.key}) {
    Get.put(CommunicationController('left'), tag: 'left');
    Get.put(CommunicationController('right'), tag: 'right');
    Get.put(PianoController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: const [
                Expanded(flex: 1, child: CommunicationWidget(tag: 'left')),
                Expanded(flex: 1, child: CommunicationWidget(tag: 'right')),
              ],
            ),
          ),
          const Expanded(
            flex: 7,
            child: PianoWidget(),
          ),
        ],
      ),
    );
  }
}
