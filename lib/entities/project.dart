import 'instrument.dart';

class Project {
  static const maxTrackCount = 3;

  final String name;
  final List<Instrument> instruments;

  Project({required this.name, required this.instruments});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] ?? '',
      instruments: List<Map<String, dynamic>>.from(json['instruments'] ?? [])
          .map((x) => Instrument.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'instruments': instruments.map((e) => e.toJson()).toList(),
      };
}
