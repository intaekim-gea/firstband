import 'instrument.dart';

class Appliance {
  static const maxTrackCount = 3;

  final String name;
  final List<Instrument> instruments;
  final String beanMac;

  Appliance({
    required this.name,
    required this.instruments,
    required this.beanMac,
  });

  factory Appliance.fromJson(Map<String, dynamic> json) {
    return Appliance(
      name: json['name'] ?? '',
      instruments: List<Map<String, dynamic>>.from(json['instruments'] ?? [])
          .map((x) => Instrument.fromJson(x))
          .toList(),
      beanMac: json['beanMac'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'instruments': instruments.map((e) => e.toJson()).toList(),
        'beanMac': beanMac,
      };
}
