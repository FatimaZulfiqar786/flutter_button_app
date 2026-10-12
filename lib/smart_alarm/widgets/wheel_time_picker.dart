import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WheelTimePicker extends StatefulWidget {
  final int initialHour; // 1-12
  final int initialMinute; // 0-59
  final String initialPeriod; // AM or PM
  final Function(int hour, int minute, String period) onTimeChanged;

  const WheelTimePicker({
    super.key,
    required this.initialHour,
    required this.initialMinute,
    required this.initialPeriod,
    required this.onTimeChanged,
  });

  @override
  State<WheelTimePicker> createState() => _WheelTimePickerState();
}

class _WheelTimePickerState extends State<WheelTimePicker> {
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minController;
  late FixedExtentScrollController _periodController;

  late int _selectedHour;
  late int _selectedMinute;
  late String _selectedPeriod;

  final double _itemExtent = 44.0;

  @override
  void initState() {
    super.initState();
    _selectedHour = widget.initialHour;
    _selectedMinute = widget.initialMinute;
    _selectedPeriod = widget.initialPeriod;

    _hourController = FixedExtentScrollController(initialItem: _selectedHour - 1);
    _minController = FixedExtentScrollController(initialItem: _selectedMinute);
    _periodController = FixedExtentScrollController(
      initialItem: _selectedPeriod == 'AM' ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  void _notifyChange() {
    widget.onTimeChanged(_selectedHour, _selectedMinute, _selectedPeriod);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background selection band (translucent gray highlight strip)
          Container(
            height: _itemExtent,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0).withOpacity(0.55),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 3 Scroll Wheels: Hour, Minute, Period (AM/PM)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. HOUR WHEEL
              SizedBox(
                width: 70,
                child: ListWheelScrollView.useDelegate(
                  controller: _hourController,
                  itemExtent: _itemExtent,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedHour = (index % 12) + 1;
                    });
                    _notifyChange();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final h = (index % 12) + 1;
                      final isSelected = h == _selectedHour;
                      return Center(
                        child: Text(
                          h.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isSelected ? 26 : 20,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Colon separator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  ':',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),

              // 2. MINUTE WHEEL
              SizedBox(
                width: 70,
                child: ListWheelScrollView.useDelegate(
                  controller: _minController,
                  itemExtent: _itemExtent,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedMinute = index % 60;
                    });
                    _notifyChange();
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final m = index % 60;
                      final isSelected = m == _selectedMinute;
                      return Center(
                        child: Text(
                          m.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: isSelected ? 26 : 20,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 3. AM / PM WHEEL
              SizedBox(
                width: 60,
                child: ListWheelScrollView(
                  controller: _periodController,
                  itemExtent: _itemExtent,
                  perspective: 0.003,
                  diameterRatio: 1.5,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedPeriod = index == 0 ? 'AM' : 'PM';
                    });
                    _notifyChange();
                  },
                  children: [
                    Center(
                      child: Text(
                        'AM',
                        style: TextStyle(
                          fontSize: _selectedPeriod == 'AM' ? 20 : 16,
                          fontWeight: _selectedPeriod == 'AM'
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: _selectedPeriod == 'AM'
                              ? const Color(0xFFFF5268)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'PM',
                        style: TextStyle(
                          fontSize: _selectedPeriod == 'PM' ? 20 : 16,
                          fontWeight: _selectedPeriod == 'PM'
                              ? FontWeight.bold
                              : FontWeight.w400,
                          color: _selectedPeriod == 'PM'
                              ? const Color(0xFFFF5268)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
