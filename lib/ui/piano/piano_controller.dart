import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:get/get.dart';

class PianoController extends GetxController {
  final _flutterMidi = FlutterMidi();

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

  void playNote(int midi) {
    _flutterMidi.playMidiNote(midi: midi);
  }
}
