import 'appliance.dart';

class Project {
  final String name;
  final List<Appliance> appliances;

  Project({required this.name, required this.appliances});

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] ?? '',
      appliances: List<Map<String, dynamic>>.from(json['appliances'] ?? [])
          .map((x) => Appliance.fromJson(x))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'appliances': appliances.map((e) => e.toJson()).toList(),
      };
}
