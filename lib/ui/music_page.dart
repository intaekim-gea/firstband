import 'dart:async';

import 'package:firstband/ui/communications/communication_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MusicController extends GetxController {
  final String beanControllerTag;
  CommunicationController get beanController => Get.find(
        tag: beanControllerTag,
      );
  final buttonController = RoundedLoadingButtonController();

  MusicController(this.beanControllerTag);

  void playMusic() {}
}

class MusicPage extends GetView<MusicController> {
  static const name = '/music';
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: RoundedLoadingButton(
          color: Get.theme.primaryColor,
          controller: controller.buttonController,
          onPressed: () async {
            controller.playMusic();

            await Future.delayed(const Duration(milliseconds: 2000));
            controller.buttonController.success();
            await Future.delayed(const Duration(milliseconds: 1000));
            controller.buttonController.reset();
          },
          child: const Text('Play', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
