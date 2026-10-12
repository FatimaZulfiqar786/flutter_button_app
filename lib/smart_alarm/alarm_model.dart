class AlarmModel {
  final String id;
  int hour; // 1-12
  int minute; // 0-59
  String period; // AM or PM
  List<int> activeDays; // 0 for Mon, 1 for Tue, ..., 6 for Sun
  bool isEnabled;
  bool snoozeEnabled;
  int snoozeMinutes;
  String soundName;
  String label;

  AlarmModel({
    required this.id,
    required this.hour,
    required this.minute,
    required this.period,
    required this.activeDays,
    this.isEnabled = true,
    this.snoozeEnabled = true,
    this.snoozeMinutes = 10,
    this.soundName = 'Jungle Morning',
    this.label = 'Alarm',
  });

  String get timeFormatted {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get displayTimeString {
    final h = hour.toString();
    final m = minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  AlarmModel copyWith({
    String? id,
    int? hour,
    int? minute,
    String? period,
    List<int>? activeDays,
    bool? isEnabled,
    bool? snoozeEnabled,
    int? snoozeMinutes,
    String? soundName,
    String? label,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      period: period ?? this.period,
      activeDays: activeDays ?? List.from(this.activeDays),
      isEnabled: isEnabled ?? this.isEnabled,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeMinutes: snoozeMinutes ?? this.snoozeMinutes,
      soundName: soundName ?? this.soundName,
      label: label ?? this.label,
    );
  }
}
