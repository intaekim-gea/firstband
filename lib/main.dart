import 'dart:async';

import 'package:firstband/my_app.dart';
import 'package:firstband/ui/model_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

Future<void> locate() async {
  Get.put(ModelController(), permanent: true);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locate();
  // await SystemChrome.setPreferredOrientations(
  //   [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  // );
  runApp(const MyApp());
}
