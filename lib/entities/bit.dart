class Bit {
  final int msec;
  final int? value;

  Bit({required this.msec, required this.value});

  factory Bit.fromJson(Map<String, dynamic> json) => Bit(
        msec: int.parse(json['msec'] ?? '0'),
        value: int.tryParse(json['value']),
      );

  Map<String, dynamic> toJson() => {
        'msec': '$msec',
        if (value != null) 'value': '$value',
      };
}
