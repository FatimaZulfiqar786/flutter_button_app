import 'package:flutter/material.dart';

// Course: Mobile Application Development (MAD)
// Student Roll No: FA24-BCS-244
// Teacher: Sir Jamshed Iqbal
// Project: Smart Alarm App (First 4 Screens)

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Screen1Home(),
  ));
}

// Coral-Pink Color from Assignment Design
const Color coralColor = Color(0xFFFF5268);

// ========================================================
// 1. SCREEN 1: ALARM HOME DASHBOARD
// ========================================================
class Screen1Home extends StatefulWidget {
  const Screen1Home({super.key});

  @override
  State<Screen1Home> createState() => _Screen1HomeState();
}

class _Screen1HomeState extends State<Screen1Home> {
  // Alarms List
  List<Map<String, dynamic>> alarms = [
    {"time": "06:20 AM", "enabled": true, "sound": "Jungle Morning"},
    {"time": "05:00 AM", "enabled": true, "sound": "Ceramic"},
    {"time": "07:00 AM", "enabled": false, "sound": "Rooster Crow"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E293B)),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu clicked")),
            );
          },
        ),
        actions: const [
          Icon(Icons.person_outline, color: Color(0xFF1E293B)),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Next Active Alarm Card (Display Top Alarm)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
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
                    const Icon(Icons.alarm, size: 55, color: coralColor),
                    const SizedBox(height: 10),
                    Text(
                      alarms.isNotEmpty ? alarms.first["time"] : "07:20 AM",
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: coralColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "FRIDAY, 12 JUNE 2026",
                      style: TextStyle(color: Colors.grey, fontSize: 13, letterSpacing: 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Your Alarms",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),

              // Alarms List
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: alarms.isEmpty
                      ? const Center(
                          child: Text(
                            "No alarms set. Tap + to add one!",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          itemCount: alarms.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = alarms[index];
                            final bool isEnabled = item["enabled"];
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                              title: Text(
                                item["time"],
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isEnabled ? coralColor : Colors.grey.shade400,
                                ),
                              ),
                              subtitle: Text(
                                "Sound: ${item["sound"] ?? "Default"}",
                                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                              ),
                              trailing: Switch(
                                value: isEnabled,
                                activeColor: coralColor,
                                onChanged: (val) {
                                  setState(() {
                                    item["enabled"] = val;
                                  });
                                },
                              ),
                              onTap: () async {
                                // Go to Screen 3 (Edit Alarm)
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Screen3Edit(
                                      alarmTime: item["time"],
                                      index: index,
                                    ),
                                  ),
                                );
                                if (result != null) {
                                  if (result["action"] == "delete") {
                                    setState(() {
                                      alarms.removeAt(index);
                                    });
                                  } else if (result["action"] == "update") {
                                    setState(() {
                                      alarms[index]["time"] = result["time"];
                                    });
                                  }
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

      // Floating Action Button (+) -> Go to Screen 2 (Set Alarm)
      floatingActionButton: FloatingActionButton(
        backgroundColor: coralColor,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () async {
          final newAlarm = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Screen2Set()),
          );
          if (newAlarm != null && newAlarm is Map<String, dynamic>) {
            setState(() {
              alarms.add(newAlarm);
            });
          }
        },
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

// ========================================================
// 2. SCREEN 2: SET ALARM SCREEN
// ========================================================
class Screen2Set extends StatefulWidget {
  const Screen2Set({super.key});

  @override
  State<Screen2Set> createState() => _Screen2SetState();
}

class _Screen2SetState extends State<Screen2Set> {
  TimeOfDay selectedTime = const TimeOfDay(hour: 7, minute: 20);
  bool snooze = true;
  String selectedSound = "Jungle Morning";
  List<String> days = ["M", "T", "W", "T", "F", "S", "S"];
  Set<int> selectedDays = {1, 2, 3, 4}; // Tuesday to Friday default

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final min = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "${hour.toString().padLeft(2, '0')} : $min $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Set Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Interactive Time Display Card (Tap to pick time)
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (picked != null) {
                    setState(() => selectedTime = picked);
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
                        _formatTime(selectedTime),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: coralColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Tap to change time",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Repeat Days Row (Multi-select)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
                        backgroundColor: isSelected ? coralColor : Colors.grey.shade100,
                        child: Text(
                          days[i],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 16),

              // Snooze & Sound Selection Card
              Container(
                padding: const EdgeInsets.all(18),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "SNOOZE (10 mins)",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        Switch(
                          value: snooze,
                          activeColor: coralColor,
                          onChanged: (v) => setState(() => snooze = v),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "ALARM SOUND",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      subtitle: Text(
                        selectedSound,
                        style: const TextStyle(color: coralColor, fontWeight: FontWeight.w600),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                      onTap: () async {
                        // Go to Screen 4 (Sound Picker)
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Screen4Sound(initialSound: selectedSound),
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

              // Save Alarm Button (Wrapped in SafeArea with padding)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: coralColor,
                    minimumSize: const Size(double.infinity, 54),
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                  ),
                  onPressed: () {
                    // Return new alarm data to Screen 1
                    Navigator.pop(context, {
                      "time": _formatTime(selectedTime).replaceAll(" ", ""),
                      "enabled": true,
                      "sound": selectedSound,
                    });
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

// ========================================================
// 3. SCREEN 3: EDIT ALARM SCREEN
// ========================================================
class Screen3Edit extends StatefulWidget {
  final String alarmTime;
  final int index;
  const Screen3Edit({super.key, required this.alarmTime, required this.index});

  @override
  State<Screen3Edit> createState() => _Screen3EditState();
}

class _Screen3EditState extends State<Screen3Edit> {
  late String currentTime;

  @override
  void initState() {
    super.initState();
    currentTime = widget.alarmTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Alarm",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Alarm Time Card
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: const TimeOfDay(hour: 6, minute: 20),
                  );
                  if (picked != null) {
                    final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
                    final min = picked.minute.toString().padLeft(2, '0');
                    final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
                    setState(() {
                      currentTime = "${hour.toString().padLeft(2, '0')}:$min $period";
                    });
                  }
                },
                child: Container(
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
                        currentTime,
                        style: const TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: coralColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Tap to change time",
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // 3 Bottom Action Buttons: CANCEL, DELETE, SAVE
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    // CANCEL BUTTON
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: coralColor, width: 1.5),
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "CANCEL",
                          style: TextStyle(color: coralColor, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // DELETE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          elevation: 0,
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {"action": "delete"});
                        },
                        child: const Text(
                          "DELETE",
                          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // SAVE BUTTON
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: coralColor,
                          elevation: 2,
                          minimumSize: const Size(0, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          Navigator.pop(context, {
                            "action": "update",
                            "time": currentTime,
                          });
                        },
                        child: const Text(
                          "SAVE",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
    );
  }
}

// ========================================================
// 4. SCREEN 4: ALARM SOUND PICKER SCREEN
// ========================================================
class Screen4Sound extends StatefulWidget {
  final String initialSound;
  const Screen4Sound({super.key, this.initialSound = "Jungle Morning"});

  @override
  State<Screen4Sound> createState() => _Screen4SoundState();
}

class _Screen4SoundState extends State<Screen4Sound> {
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
    chosen = widget.initialSound;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context, chosen),
        ),
        title: const Text(
          "Alarm Sound Picker",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, chosen),
            child: const Text(
              "SAVE",
              style: TextStyle(color: coralColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                final isSelected = (chosen == sounds[i]);
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: Text(
                    sounds[i],
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? coralColor : const Color(0xFF1E293B),
                      fontSize: 16,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: coralColor)
                      : null,
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
