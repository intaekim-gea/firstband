import 'dart:async';

import 'package:firstband/my_app.dart';
import 'package:flutter/material.dart';

Future<void> locate() async {
  // final datasource = GeaDatasource();
  // final datasource = MockCommunicationAdapter();
  // await datasource.initialize();
  // Get.put<CommunicationAdapter>(datasource);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await locate();
  runApp(const MyApp());
}
