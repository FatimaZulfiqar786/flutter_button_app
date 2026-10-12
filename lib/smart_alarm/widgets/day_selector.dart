import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {
  final List<int> selectedDays; // 0: Mon, 1: Tue, ..., 6: Sun
  final ValueChanged<List<int>> onDaysChanged;
  final Color activeColor;

  const DaySelector({
    super.key,
    required this.selectedDays,
    required this.onDaysChanged,
    this.activeColor = const Color(0xFFFF5268),
  });

  static const List<String> dayHeaders = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const List<String> dayPills = ['Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top letter row (M T W T F S S)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = selectedDays.contains(index);
            return SizedBox(
              width: 42,
              child: Center(
                child: Text(
                  dayHeaders[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        // Pills row (rounded rectangles)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(7, (index) {
            final isSelected = selectedDays.contains(index);
            return GestureDetector(
              onTap: () {
                final updated = List<int>.from(selectedDays);
                if (isSelected) {
                  updated.remove(index);
                } else {
                  updated.add(index);
                  updated.sort();
                }
                onDaysChanged(updated);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42,
                height: 38,
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    dayPills[index],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
