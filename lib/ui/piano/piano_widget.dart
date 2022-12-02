import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:get/get.dart';
import 'package:piano/piano.dart';

import 'piano_controller.dart';

class PianoWidget extends GetView<PianoController> {
  const PianoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractivePiano(
        highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
        naturalColor: Colors.white,
        accidentalColor: Colors.black,
        keyWidth: 60,
        noteRange: NoteRange.forClefs([
          Clef.Treble,
        ], extended: true),
        onNotePositionTapped: (position) {
          final pitch = position.pitch;
          controller.playNote(pitch);
        },
      ),
    );
  }
}
