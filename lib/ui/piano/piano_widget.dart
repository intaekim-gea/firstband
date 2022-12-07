import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:piano/piano.dart';

import 'piano_controller.dart';

class PianoWidget extends GetView<PianoController> {
  const PianoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractivePiano(
        highlightedNotes: [NotePosition(note: Note.C, octave: 5)],
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
