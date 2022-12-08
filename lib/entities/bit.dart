const otaveMap = {
  'Octave2DoSharp': 0,
  'Octave2Re': 1,
  'Octave2ReSharp': 2,
  'Octave2Fa': 3,
  'Octave2FaSharp': 4,
  'Octave2Sol': 5,
  'Octave2La': 6,
  'Octave3DoSharp': 7,
  'Octave3Re': 8,
  'Octave3ReSharp': 9,
  'Octave3Fa': 10,
  'Octave3FaSharp': 11,
  'Octave3Sol': 12,
  'Octave3La': 13,

  'Octave4Do': 14,
  'Octave4Re': 15,
  'Octave4Mi': 16,
  'Octave4Pa': 17,
  'Octave4Sol': 18,
  'Octave4SolSharp': 19,
  'Octave4La': 20,
  'Octave4LaSharp': 21,
  'Octave4Ci': 22,
  'Octave5Do': 23, //0x17
  'Octave5DoSharp': 24, //0x18
  'Octave5Re': 25, // 0x19
  'Octave5ReSharp': 26, //0x1A
  'Octave5Mi': 27, // 0x1B
  'Octave5Pa': 28, //0x1C
  'Octave5PaSharp': 29, //0x1D
  'Octave5Sol': 30, //0x1E
  'Octave5SolSharp': 31, //0x1F
  'Octave5La': 32, //0x20
  'Octave5LaSharp': 33, //0x21
  'Octave5Ci': 34, //0x22

  'Octave6Do': 35, //0x23
  'Octave6DoSharp': 36,
  'Octave6Re': 37,
  'Octave6ReSharp': 38,
  'Octave6Mi': 39,
  'Octave6Pa': 40,
  'Octave6PaSharp': 41,
  'Octave6Sol': 42,
  'Octave6La': 43,
  'Octave6Ci': 44,
  'Mute': 45,
};

class Bit {
  final int msec;
  final int? value;

  Bit({required this.msec, required this.value});

  factory Bit.fromJson(Map<String, dynamic> json) {
    int? value;
    if (double.tryParse(json['value']) != null) {
      value = int.tryParse(json['value']);
    } else {
      value = otaveMap[json['value']];
      if (value != null) {
        value -= (0x17 - 72);
      } else {
        print('object');
      }
    }

    return Bit(
      msec: int.parse(json['msec'] ?? '0'),
      value: value,
    );
  }

  Map<String, dynamic> toJson() => {
        'msec': '$msec',
        if (value != null) 'value': '$value',
      };
}
