import 'dart:async';

import 'package:firstband/entities/appliance.dart';
import 'package:firstband/ui/communications/communication_controller.dart';
import 'package:firstband/ui/main_page.dart';
import 'package:firstband/ui/piano/piano_controller.dart';
import 'package:get/get.dart';

import '../entities/instrument.dart';
import '../entities/project.dart';
import 'appliance/appliance_tracks.dart';

class ModelController extends GetxController {
  final project = Project(name: '', appliances: []).obs;

  // static const intervalPerSec = 400.0;
  // var trackWidth = 15000.0;
  static const intervalPerSec = 200.0;
  var trackWidth = 7500.0;
  List<Timer> playTimers = [];

  double get totalPlayTimeInMilliSec => (trackWidth / intervalPerSec) * 1000;

  ModelController({Project? aProject}) {
    if (aProject == null) {
      project.value = Project(name: 'Untitled', appliances: [
        Appliance(
          name: 'Washer1',
          instruments: [
            Instrument(kind: KindOfInstrument.buzz, bits: []),
          ],
          beanMac: kRight,
        ),
      ]);
    } else {
      project.value = aProject;
    }

    // project.listen((project) {
    // 1:400 = project.totalMilliSec / 1000.0 : x;
    // });
  }

  void setProject(Project project) {
    this.project.value = project;
  }

  bool addInstrument(Appliance appliance, Instrument instrument) {
    if (appliance.instruments.length >= Appliance.maxTrackCount) {
      return false;
    }
    return true;
  }

  void _playAppliance(Appliance appliance, {bool isStop = false}) {
    final tag = appliance.name == 'Washer1' ? kLeft : kRight;
    final music = {
      'Imperial March': {
        kLeft: 'f403',
        kRight: 'f404',
      },
      'Dance Monkey': {
        kLeft: 'f405',
        kRight: 'f406',
      },
      'All I Want For Christmas is You': {
        kLeft: 'f407',
        kRight: 'f407',
      },
    };

    final comm = Get.find<CommunicationController>(tag: tag);
    final model = Get.find<ModelController>();
    final erd = music[model.project.value.name]?[tag];
    assert(erd != null);
    if (erd != null) {
      if (isStop) {
        comm.stopMusic(erd);
        return;
      } else {
        if (tag == kRight) {
          Future.delayed(const Duration(milliseconds: 20))
              .then((value) => comm.playMusic(erd));
        } else {
          comm.playMusic(erd);
        }

        // if ('All I Want For Christmas is You' == model.project.value.name) {
        //   Future.delayed(const Duration(milliseconds: 500)).then((value) {
        //     comm.playDrainPump();
        //   });
        // }
      }
    }
    // return;

    final trackContainerController = Get.find<ApplianceTracksController>();
    final pianoController = Get.find<PianoController>(tag: tag);
    // x : totalsec = offset : trackwidth
    final startMilliSec = totalPlayTimeInMilliSec *
        trackContainerController.scrollControllers.offset /
        trackWidth;

    for (var appliance in project.value.appliances) {
      final instrument = appliance.instruments.first;
      for (var bit in instrument.bits) {
        if (bit.msec > startMilliSec) {
          final after = bit.msec - startMilliSec.toInt();
          print('afeter: $after msec');
          final timer = Timer(Duration(milliseconds: after), () {
            if (bit.value != null) {
              // print(
              //     'offset: ${trackContainerController.scrollControllers.offset}');
              pianoController.playNote(bit.value!, withBean: false);
            }
          });
          playTimers.add(timer);
        }
      }
    }
  }

  void play() {
    // stop();
    final trackContainerController = Get.find<ApplianceTracksController>();
    trackContainerController.scrollControllers.jumpTo(0);
    trackContainerController.play();

    for (var appliance in project.value.appliances) {
      _playAppliance(appliance);
    }
  }

  void stop() {
    final trackContainerController = Get.find<ApplianceTracksController>();
    trackContainerController.scrollControllers.resetScroll();

    for (var timer in playTimers) {
      timer.cancel();
    }
    playTimers.clear();

    final left = Get.find<CommunicationController>(tag: kLeft);
    final right = Get.find<CommunicationController>(tag: kRight);

    for (var appliance in project.value.appliances) {
      _playAppliance(appliance, isStop: true);
    }

    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      left.stopDrainPump();
      // left.stopLidLock();
      // right.stopLidLock();
      right.stopDrainPump();
    });
  }
}
