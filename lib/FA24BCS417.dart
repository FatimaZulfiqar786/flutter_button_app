// ==============================================================================
// Course: Mobile Application Development (MAD)
// Submitted to: Sir Jamshed Iqbal
// Submitted by: Fatima Zulfiqar
// Registration No: FA24-BCS-417
// Project: Smart Alarm App (First 4 Screens - Beginner Friendly Code for Viva)
// ==============================================================================

import 'package:flutter/material.dart';

void main() {
  runApp(const SmartAlarmApp());
}

// Assignment Theme Color (Coral Pink: #FF5268)
const Color coral = Color(0xFFFF5268);

class SmartAlarmApp extends StatelessWidget {
  const SmartAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Alarm',
      home: Screen1Home(),
    );
  }
}

// ==============================================================================
// SCREEN 1: ALARM HOME & ACTIVE ALARM SCREEN (MAIN DASHBOARD)
// ==============================================================================
class Screen1Home extends StatefulWidget {
  const Screen1Home({super.key});

  @override
  State<Screen1Home> createState() => _Screen1HomeState();
}

class _Screen1HomeState extends State<Screen1Home> {
  // Selected tab index: 0 = ALARM, 1 = TIMER, 2 = STOPWATCH
  int selectedTab = 0;

  // Saved alarms list (As shown in PDF: 6:20 AM, 5:00 AM, 7:00 AM)
  List<String> alarmTimes = ["6:20 AM", "5:00 AM", "7:00 AM"];
  List<bool> alarmSwitches = [true, true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      // 1. TOP APP BAR (Hamburger Menu icon and Home icon)
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF1E293B)),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Icon(Icons.home_outlined, color: Color(0xFF1E293B), size: 26),
          SizedBox(width: 16),
        ],
      ),

      // 2. NAVIGATION DRAWER (Shown when hamburger menu is tapped)
      drawer: Drawer(
        backgroundColor: coral,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(24),
                child: Row(
                  children: [
                    Icon(Icons.alarm, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      "Smart Alarm",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              _drawerItem(Icons.dashboard_outlined, "Dashboard"),
              _drawerItem(Icons.alarm_outlined, "Alarms"),
              _drawerItem(Icons.hourglass_empty, "Timer"),
              _drawerItem(Icons.timer_outlined, "Stopwatch"),
              _drawerItem(Icons.settings_outlined, "Settings"),
              _drawerItem(Icons.person_outline, "Profile"),
            ],
          ),
        ),
      ),

      // 3. MAIN BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              // SEGMENTED TABS (ALARM, TIMER, STOPWATCH)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    _buildTabButton("ALARM", 0),
                    _buildTabButton("TIMER", 1),
                    _buildTabButton("STOPWATCH", 2),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // CENTER CARD: ACTIVE ALARM CARD (7:20 AM - Twin Bells clock)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    // Alarm twin-bell icon
                    Icon(Icons.alarm, size: 60, color: coral),
                    SizedBox(height: 8),
                    // Next active alarm time
                    Text(
                      "7:20 AM",
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        color: coral,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "FRIDAY, 12 JUNE 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // SCROLLABLE SAVED ALARMS LIST
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: alarmTimes.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final time = alarmTimes[index];
                      final isEnabled = alarmSwitches[index];
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        title: Text(
                          time,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isEnabled ? coral : Colors.grey.shade400,
                          ),
                        ),
                        trailing: Switch(
                          value: isEnabled,
                          activeColor: coral,
                          onChanged: (val) {
                            setState(() => alarmSwitches[index] = val);
                          },
                        ),
                        onTap: () async {
                          // Tap opens Screen 3: Edit Alarm Screen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Screen3Edit(alarmTime: time),
                            ),
                          );
                          if (result == "delete") {
                            setState(() {
                              alarmTimes.removeAt(index);
                              alarmSwitches.removeAt(index);
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // 4. FLOATING ACTION BUTTON (+) -> Opens Screen 2: Set Alarm
      floatingActionButton: FloatingActionButton(
        backgroundColor: coral,
        shape: const CircleBorder(),
        elevation: 4,
        onPressed: () async {
          final newTime = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Screen2Set()),
          );
          if (newTime != null && newTime is String) {
            setState(() {
              alarmTimes.add(newTime);
              alarmSwitches.add(true);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  // Helper widget for segmented tabs
  Widget _buildTabButton(String title, int index) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? coral : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for drawer items
  Widget _drawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      onTap: () => Navigator.pop(context),
    );
  }
}

// ==============================================================================
// SCREEN 2: SET ALARM SCREEN (NEW ALARM CREATION)
// ==============================================================================
class Screen2Set extends StatefulWidget {
  const Screen2Set({super.key});

  @override
  State<Screen2Set> createState() => _Screen2SetState();
}

class _Screen2SetState extends State<Screen2Set> {
  // Current time selection (Default: 07:20 AM from PDF)
  String displayTime = "07 : 20 AM";
  TimeOfDay timeVal = const TimeOfDay(hour: 7, minute: 20);

  // Repeat days pills (M T W T F S S)
  List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
  Set<int> selectedDays = {1, 2, 3, 4}; // Tuesday to Friday highlighted

  // Snooze switch and Alarm sound
  bool snoozeEnabled = true;
  String selectedSound = "Jungle Morning";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      // TOP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Set Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
      ),

      // BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. DIGITAL TIME CARD (Tap to pick time)
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: timeVal);
                  if (picked != null) {
                    setState(() {
                      timeVal = picked;
                      final h = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
                      final m = picked.minute.toString().padLeft(2, '0');
                      final p = picked.period == DayPeriod.am ? 'AM' : 'PM';
                      displayTime = "${h.toString().padLeft(2, '0')} : $m $p";
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        displayTime,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: coral,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text("Tap to change time", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. RECURRING DAYS ROW (M T W T F S S)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(days.length, (i) {
                    final isSelected = selectedDays.contains(i);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedDays.remove(i);
                          } else {
                            selectedDays.add(i);
                          }
                        });
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: isSelected ? coral : Colors.grey.shade100,
                        child: Text(
                          days[i],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // 3. SNOOZE AND ALARM SOUND CARD
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Snooze Switch (10 mins)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("SNOOZE (10 mins)", style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: snoozeEnabled,
                          activeColor: coral,
                          onChanged: (v) => setState(() => snoozeEnabled = v),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    // Alarm Sound Option -> Opens Screen 4
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("ALARM SOUND", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      subtitle: Text(selectedSound, style: const TextStyle(color: coral, fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Screen4Sound(currentSound: selectedSound),
                          ),
                        );
                        if (result != null && result is String) {
                          setState(() => selectedSound = result);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // 4. SAVE ALARM BUTTON
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coral,
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  ),
                  onPressed: () {
                    // Returns the formatted alarm time back to Screen 1
                    Navigator.pop(context, displayTime.replaceAll(" ", ""));
                  },
                  child: const Text(
                    "SAVE ALARM",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==============================================================================
// SCREEN 3: EDIT ALARM SCREEN (MODIFICATION & DELETION)
// ==============================================================================
class Screen3Edit extends StatefulWidget {
  final String alarmTime;
  const Screen3Edit({super.key, required this.alarmTime});

  @override
  State<Screen3Edit> createState() => _Screen3EditState();
}

class _Screen3EditState extends State<Screen3Edit> {
  late String timeText;

  @override
  void initState() {
    super.initState();
    timeText = widget.alarmTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      // TOP BAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
      ),

      // BODY
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. TIME DISPLAY CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      timeText,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: coral,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text("Alarm Scheduled", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),

              const Spacer(),

              // 2. BOTTOM 3 ACTION BUTTONS (CANCEL, DELETE, SAVE)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // CANCEL BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coral,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("CANCEL", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // DELETE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coral,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () => Navigator.pop(context, "delete"),
                        child: const Text("DELETE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // SAVE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coral,
                          minimumSize: const Size(0, 48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () => Navigator.pop(context, "save"),
                        child: const Text("SAVE", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==============================================================================
// SCREEN 4: ALARM SOUND PICKER SCREEN (TONE SELECTION)
// ==============================================================================
class Screen4Sound extends StatefulWidget {
  final String currentSound;
  const Screen4Sound({super.key, required this.currentSound});

  @override
  State<Screen4Sound> createState() => _Screen4SoundState();
}

class _Screen4SoundState extends State<Screen4Sound> {
  // 5 Tones exactly from the PDF
  final List<String> sounds = [
    "Jungle Morning",
    "Ceramic",
    "Rooster Crow",
    "Ocean Breeze",
    "Electric Bell",
  ];
  late String chosen;

  @override
  void initState() {
    super.initState();
    chosen = widget.currentSound;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),

      // TOP BAR WITH SAVE BUTTON
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context, chosen),
        ),
        title: const Text(
          "Alarm Sound Picker",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, chosen),
            child: const Text(
              "SAVE",
              style: TextStyle(color: coral, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      // TONES LIST
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: sounds.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final isSelected = chosen == sounds[i];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: Text(
                    sounds[i],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? coral : const Color(0xFF1E293B),
                      fontSize: 16,
                    ),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: coral) : null,
                  onTap: () {
                    setState(() => chosen = sounds[i]);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
