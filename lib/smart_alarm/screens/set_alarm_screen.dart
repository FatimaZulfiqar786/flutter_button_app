import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../widgets/day_selector.dart';
import '../widgets/wheel_time_picker.dart';
import '../widgets/coral_pill_button.dart';
import 'sound_picker_screen.dart';

class SetAlarmScreen extends StatefulWidget {
  final Function(AlarmModel) onAlarmCreated;

  const SetAlarmScreen({
    super.key,
    required this.onAlarmCreated,
  });

  @override
  State<SetAlarmScreen> createState() => _SetAlarmScreenState();
}

class _SetAlarmScreenState extends State<SetAlarmScreen> {
  int _selectedHour = 7;
  int _selectedMinute = 20;
  String _selectedPeriod = 'AM';

  // Default active days: Tuesday to Sunday active, Monday inactive as seen in Image 43!
  List<int> _activeDays = [1, 2, 3, 4, 5, 6];

  bool _snoozeEnabled = false;
  final int _snoozeMinutes = 10;
  String _soundName = 'Jungle Morning';

  void _openSoundPicker() async {
    final chosenSound = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => SoundPickerScreen(currentSound: _soundName),
      ),
    );

    if (chosenSound != null) {
      setState(() {
        _soundName = chosenSound;
      });
    }
  }

  void _saveAlarm() {
    final newAlarm = AlarmModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hour: _selectedHour,
      minute: _selectedMinute,
      period: _selectedPeriod,
      activeDays: _activeDays,
      isEnabled: true,
      snoozeEnabled: _snoozeEnabled,
      snoozeMinutes: _snoozeMinutes,
      soundName: _soundName,
      label: 'Alarm',
    );

    widget.onAlarmCreated(newAlarm);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Alarm set for ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod'),
        backgroundColor: const Color(0xFFFF5268),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Set Alarm',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              // 1. Time Picker Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Select Time',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF94A3B8),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    WheelTimePicker(
                      initialHour: _selectedHour,
                      initialMinute: _selectedMinute,
                      initialPeriod: _selectedPeriod,
                      onTimeChanged: (hour, minute, period) {
                        setState(() {
                          _selectedHour = hour;
                          _selectedMinute = minute;
                          _selectedPeriod = period;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Day Selection Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'REPEAT DAYS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.8,
                          ),
                        ),
                        Text(
                          _activeDays.length == 7
                              ? 'Everyday'
                              : _activeDays.isEmpty
                                  ? 'Never'
                                  : '${_activeDays.length} days selected',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF5268),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    DaySelector(
                      selectedDays: _activeDays,
                      onDaysChanged: (days) {
                        setState(() {
                          _activeDays = days;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Snooze and Sound Settings Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Snooze row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'SNOOZE',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '$_snoozeMinutes mins',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        Switch(
                          value: _snoozeEnabled,
                          activeColor: const Color(0xFFFF5268),
                          activeTrackColor: const Color(0xFFFF5268).withOpacity(0.35),
                          onChanged: (val) {
                            setState(() {
                              _snoozeEnabled = val;
                            });
                          },
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),
                    ),

                    // Alarm sound row
                    const Text(
                      'ALARM SOUND',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sound dropdown pill
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _openSoundPicker,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.music_note_rounded,
                                    color: Color(0xFFFF5268),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _soundName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xFF64748B),
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // 4. Save Alarm Button
              CoralPillButton(
                text: 'SAVE ALARM',
                width: double.infinity,
                height: 52,
                fontSize: 15,
                onPressed: _saveAlarm,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
