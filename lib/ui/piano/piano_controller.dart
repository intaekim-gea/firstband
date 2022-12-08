import 'package:firstband/ui/communications/communication_controller.dart';
import 'package:firstband/ui/communications/notes.dart';
import 'package:firstband/ui/main_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:get/get.dart';
import 'package:shqs_util/shqs_util.dart';

class PianoController extends GetxController {
  final String _beanControllerTag;
  final _flutterMidi = FlutterMidi();

  CommunicationController get beanController => Get.find(
        tag: _beanControllerTag,
      );

  PianoController(this._beanControllerTag);

  @override
  void onInit() {
    _loadMidi();
    super.onInit();
  }

  Future<void> _loadMidi() async {
    if (kIsWeb) {
      _flutterMidi.prepare(sf2: null);
    } else {
      // const asset = 'assets/Piano.sf2';
      const asset = 'assets/YDP-GrandPiano-20160804.sf2';
      _flutterMidi.unmute();

      ByteData bytes = await rootBundle.load(asset);
      _flutterMidi.prepare(sf2: bytes, name: asset.replaceAll('assets/', ''));
    }
  }

  static const begin = 72; // 72(C5), 0x17(23)
  final notes = {
    72: BeanNote.Octave5Do, // C5 -> 0x17(23)
    73: BeanNote.Octave5DoSharp, // C#5
    74: BeanNote.Octave5Re, // D5
    75: BeanNote.Octave5ReSharp, // D#5
  };
  void playNote(int midi, {required bool withBean}) {
    if (withBean) {
      final newMidi = midi + (0x17 - 72);
      if (_beanControllerTag == kLeft)
        GeLog.e('MIDI',
            'midi: $midi, newMidi: $newMidi(0x${newMidi.hex2byteString})');
      else {
        GeLog.i('MIDI',
            'midi: $midi, newMidi: $newMidi(0x${newMidi.hex2byteString})');
      }
      beanController.playNote(newMidi);
    }

    _flutterMidi.playMidiNote(midi: midi);
  }
}
