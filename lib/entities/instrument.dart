import 'bit.dart';

enum KindOfInstrument {
  none('None'),
  buzz('Buzz'),
  drainPump('DrainPump'),
  lidLock('LidLock');

  const KindOfInstrument(this.value);
  final String value;
}

class Instrument {
  final KindOfInstrument kind;
  final List<Bit> bits;

  Instrument({required this.kind, required this.bits});

  factory Instrument.fromJson(Map<String, dynamic> json) {
    return Instrument(
      kind: KindOfInstrument.values.firstWhere(
        (e) => e.value == json['kind'],
      ),
      bits: List<Map<String, dynamic>>.from(json['bits'] ?? [])
          .map((x) => Bit.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'kind': kind.value,
        'bits': bits.map((e) => e.toJson()).toList(),
      };
}
