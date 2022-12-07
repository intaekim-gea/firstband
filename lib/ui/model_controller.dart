import 'package:firstband/entities/instrument.dart';
import 'package:get/get.dart';

import '../entities/project.dart';

class ModelController extends GetxController {
  final project = Project(name: '', instruments: []).obs;

  static const intervalPerSec = 400.0;
  var trackWidth = 5000.0;

  int get totalPlayTimeInMilliSec =>
      ((trackWidth / intervalPerSec) * 1000).toInt();

  ModelController({Project? aProject}) {
    if (aProject == null) {
      project.value = Project(name: 'Untitled', instruments: [
        Instrument(kind: KindOfInstrument.buzz, bits: []),
      ]);
    } else {
      project.value = aProject;
    }
  }

  bool addInstrument(Instrument instrument) {
    if (project.value.instruments.length >= Project.maxTrackCount) return false;
    return true;
  }
}
