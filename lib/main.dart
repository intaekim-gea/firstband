import 'dart:async';

import 'package:firstband/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> locate() async {
  // final datasource = GeaDatasource();
  // final datasource = MockCommunicationAdapter();
  // await datasource.initialize();
  // Get.put<CommunicationAdapter>(datasource);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locate();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
  );
  runApp(const MyApp());
}
