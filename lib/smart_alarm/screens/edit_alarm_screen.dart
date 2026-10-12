import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../widgets/day_selector.dart';
import '../widgets/wheel_time_picker.dart';
import '../widgets/coral_pill_button.dart';
import 'sound_picker_screen.dart';

class EditAlarmScreen extends StatefulWidget {
  final AlarmModel alarm;
  final Function(AlarmModel) onAlarmUpdated;
  final Function(String) onAlarmDeleted;

  const EditAlarmScreen({
    super.key,
    required this.alarm,
    required this.onAlarmUpdated,
    required this.onAlarmDeleted,
  });

  @override
  State<EditAlarmScreen> createState() => _EditAlarmScreenState();
}

class _EditAlarmScreenState extends State<EditAlarmScreen> {
  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod;
  late List<int> _activeDays;
  late bool _snoozeEnabled;
  late int _snoozeMinutes;
  late String _soundName;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.alarm.hour;
    _selectedMinute = widget.alarm.minute;
    _selectedPeriod = widget.alarm.period;
    _activeDays = List.from(widget.alarm.activeDays);
    _snoozeEnabled = widget.alarm.snoozeEnabled;
    _snoozeMinutes = widget.alarm.snoozeMinutes;
    _soundName = widget.alarm.soundName;
  }

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

  void _onCancel() {
    Navigator.pop(context);
  }

  void _onDelete() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Alarm'),
        content: Text(
          'Are you sure you want to delete the alarm for ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5268),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              widget.onAlarmDeleted(widget.alarm.id);
              Navigator.pop(context); // Close screen

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alarm deleted successfully'),
                  backgroundColor: Color(0xFFFF5268),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _onSave() {
    final updatedAlarm = widget.alarm.copyWith(
      hour: _selectedHour,
      minute: _selectedMinute,
      period: _selectedPeriod,
      activeDays: _activeDays,
      snoozeEnabled: _snoozeEnabled,
      snoozeMinutes: _snoozeMinutes,
      soundName: _soundName,
    );

    widget.onAlarmUpdated(updatedAlarm);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Alarm updated to ${_selectedHour.toString().padLeft(2, '0')}:${_selectedMinute.toString().padLeft(2, '0')} $_selectedPeriod',
        ),
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
          'Edit Alarm',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                            'Edit Time',
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
                  ],
                ),
              ),
            ),

            // 4. Bottom 3 Pill Buttons Row (Image 44: CANCEL, DELETE, SAVE)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CoralPillButton(
                      text: 'CANCEL',
                      height: 46,
                      fontSize: 12,
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFFFF5268),
                      onPressed: _onCancel,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CoralPillButton(
                      text: 'DELETE',
                      height: 46,
                      fontSize: 12,
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFFFF5268),
                      onPressed: _onDelete,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CoralPillButton(
                      text: 'SAVE',
                      height: 46,
                      fontSize: 12,
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xFFFF5268),
                      onPressed: _onSave,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
