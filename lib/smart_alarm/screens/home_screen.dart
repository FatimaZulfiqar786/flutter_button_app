import 'dart:async';
import 'package:flutter/material.dart';
import '../models/alarm_model.dart';
import '../widgets/alarm_clock_painter.dart';
import '../widgets/app_drawer.dart';
import '../widgets/coral_pill_button.dart';
import 'set_alarm_screen.dart';
import 'edit_alarm_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // 0: ALARM, 1: TIMER, 2: STOPWATCH
  int _selectedTab = 0;

  // Alarms list pre-populated matching the design in Image 40
  final List<AlarmModel> _alarms = [
    AlarmModel(
      id: '1',
      hour: 6,
      minute: 20,
      period: 'AM',
      activeDays: [0, 1, 2, 3, 4],
      isEnabled: true,
      soundName: 'Jungle Morning',
    ),
    AlarmModel(
      id: '2',
      hour: 5,
      minute: 0,
      period: 'AM',
      activeDays: [1, 2, 3, 4, 5, 6],
      isEnabled: true,
      soundName: 'Ceramic',
    ),
    AlarmModel(
      id: '3',
      hour: 7,
      minute: 0,
      period: 'AM',
      activeDays: [0, 6],
      isEnabled: false,
      soundName: 'Electric Bell',
    ),
  ];

  // Timer state
  int _timerSeconds = 0;
  bool _isTimerRunning = false;
  Timer? _timer;

  // Stopwatch state
  int _stopwatchMilliseconds = 0;
  bool _isStopwatchRunning = false;
  Timer? _stopwatchTimer;
  final List<String> _laps = [];

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatchTimer?.cancel();
    super.dispose();
  }

  void _addAlarm(AlarmModel newAlarm) {
    setState(() {
      _alarms.add(newAlarm);
    });
  }

  void _updateAlarm(AlarmModel updatedAlarm) {
    setState(() {
      final index = _alarms.indexWhere((a) => a.id == updatedAlarm.id);
      if (index != -1) {
        _alarms[index] = updatedAlarm;
      }
    });
  }

  void _deleteAlarm(String id) {
    setState(() {
      _alarms.removeWhere((a) => a.id == id);
    });
  }

  void _toggleAlarm(int index, bool value) {
    setState(() {
      _alarms[index].isEnabled = value;
    });
  }

  // Hero card time from Image 40
  String get _heroDisplayTime {
    final active = _alarms.where((a) => a.isEnabled).toList();
    if (active.any((a) => a.hour == 7 && a.minute == 20)) {
      return '7:20';
    }
    // Default matching mockup hero card
    return '7:20';
  }

  String get _heroDisplayPeriod => 'AM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF6F8FB),
      drawer: AppDrawer(
        selectedIndex: _selectedTab == 0 ? 1 : (_selectedTab == 1 ? 2 : 3),
        onItemSelected: (index) {
          if (index == 0 || index == 1) {
            setState(() => _selectedTab = 0);
          } else if (index == 2) {
            setState(() => _selectedTab = 1);
          } else if (index == 3) {
            setState(() => _selectedTab = 2);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${AppDrawer.menuItems[index]['title']} tapped'),
                backgroundColor: const Color(0xFFFF5268),
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Bar (☰ Alarm  👤)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 28),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  const Text(
                    'Alarm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      letterSpacing: 0.3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_outline_rounded, color: Color(0xFF1E293B), size: 26),
                    onPressed: () {
                      _showProfileModal();
                    },
                  ),
                ],
              ),
            ),

            // 2. Segmented Control Pills (ALARM, TIMER, STOPWATCH)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAEFF5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    _buildSegmentTab('ALARM', 0),
                    _buildSegmentTab('TIMER', 1),
                    _buildSegmentTab('STOPWATCH', 2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 3. Tab Body
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  _buildAlarmTab(),
                  _buildTimerTab(),
                  _buildStopwatchTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedTab == 0
          ? Container(
              margin: const EdgeInsets.only(bottom: 12, right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF5268).withOpacity(0.5),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFFF5268),
                shape: const CircleBorder(),
                elevation: 0,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SetAlarmScreen(
                        onAlarmCreated: _addAlarm,
                      ),
                    ),
                  );
                },
                child: const Icon(Icons.add, color: Colors.white, size: 30),
              ),
            )
          : null,
    );
  }

  Widget _buildSegmentTab(String title, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // SCREEN 1: ALARM MAIN DASHBOARD
  // ==========================================
  Widget _buildAlarmTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 6),

          // Hero Card with Alarm Clock illustration & Active Alarm Time
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                // Retro alarm clock illustration
                const AlarmClockIllustration(
                  size: 110,
                  color: Color(0xFFFF5268),
                ),
                const SizedBox(height: 18),

                // Large Time Display (7:20 AM)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      _heroDisplayTime,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5268),
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _heroDisplayPeriod,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5268),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Date Subtitle
                const Text(
                  'FRIDAY, 12 JUNE 2020',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Alarms List Card matching Image 40
          Container(
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
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _alarms.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (context, index) {
                  final alarm = _alarms[index];
                  final isEnabled = alarm.isEnabled;

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      // Tapping an alarm opens Screen 3 (Edit Alarm Screen)!
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditAlarmScreen(
                              alarm: alarm,
                              onAlarmUpdated: _updateAlarm,
                              onAlarmDeleted: _deleteAlarm,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Alarm Time (e.g., 6:20 AM)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  alarm.displayTimeString,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: isEnabled
                                        ? const Color(0xFFFF5268)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  alarm.period,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isEnabled
                                        ? const Color(0xFFFF5268)
                                        : const Color(0xFFCBD5E1),
                                  ),
                                ),
                              ],
                            ),

                            // Right toggle container matching mockup
                            Row(
                              children: [
                                Switch(
                                  value: isEnabled,
                                  activeColor: const Color(0xFFFF5268),
                                  activeTrackColor: const Color(0xFFFF5268).withOpacity(0.35),
                                  inactiveThumbColor: const Color(0xFFCBD5E1),
                                  inactiveTrackColor: const Color(0xFFF1F5F9),
                                  onChanged: (val) => _toggleAlarm(index, val),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 80), // Padding for FAB
        ],
      ),
    );
  }

  // ==========================================
  // SCREEN 5: TIMER SCREEN
  // ==========================================
  Widget _buildTimerTab() {
    final hours = (_timerSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_timerSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_timerSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.hourglass_bottom_rounded,
                  size: 54,
                  color: Color(0xFFFF5268),
                ),
                const SizedBox(height: 20),
                Text(
                  '${hours}h : ${minutes}m : ${seconds}s',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'COUNTDOWN TIMER',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          Row(
            children: [
              Expanded(
                child: CoralPillButton(
                  text: _isTimerRunning ? 'PAUSE' : 'START',
                  height: 50,
                  fontSize: 14,
                  onPressed: () {
                    setState(() {
                      if (_isTimerRunning) {
                        _timer?.cancel();
                        _isTimerRunning = false;
                      } else {
                        _isTimerRunning = true;
                        _timer = Timer.periodic(const Duration(seconds: 1), (t) {
                          setState(() {
                            _timerSeconds++;
                          });
                        });
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CoralPillButton(
                  text: 'RESET',
                  height: 50,
                  fontSize: 14,
                  backgroundColor: const Color(0xFF334155),
                  onPressed: () {
                    setState(() {
                      _timer?.cancel();
                      _isTimerRunning = false;
                      _timerSeconds = 0;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SCREEN 6: STOPWATCH SCREEN (Image 56)
  // ==========================================
  Widget _buildStopwatchTab() {
    final secs = (_stopwatchMilliseconds ~/ 100).toString().padLeft(2, '0');
    final ms = (_stopwatchMilliseconds % 100).toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${secs}s',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF5268),
                      ),
                    ),
                    const Text(
                      ' : ',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      ms,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'PRECISION LAP TIMER',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Controls matching Image 56: START & LAP, and RESET
          Row(
            children: [
              Expanded(
                child: CoralPillButton(
                  text: _isStopwatchRunning ? 'PAUSE' : 'START',
                  height: 46,
                  fontSize: 13,
                  onPressed: () {
                    setState(() {
                      if (_isStopwatchRunning) {
                        _stopwatchTimer?.cancel();
                        _isStopwatchRunning = false;
                      } else {
                        _isStopwatchRunning = true;
                        _stopwatchTimer = Timer.periodic(
                          const Duration(milliseconds: 10),
                          (t) {
                            setState(() {
                              _stopwatchMilliseconds++;
                            });
                          },
                        );
                      }
                    });
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: CoralPillButton(
                  text: 'LAP',
                  height: 46,
                  fontSize: 13,
                  backgroundColor: const Color(0xFF334155),
                  onPressed: () {
                    if (_isStopwatchRunning) {
                      setState(() {
                        _laps.insert(0, '${secs}s : $ms');
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          CoralPillButton(
            text: 'RESET',
            width: double.infinity,
            height: 46,
            fontSize: 13,
            backgroundColor: const Color(0xFF475569),
            onPressed: () {
              setState(() {
                _stopwatchTimer?.cancel();
                _isStopwatchRunning = false;
                _stopwatchMilliseconds = 0;
                _laps.clear();
              });
            },
          ),

          const SizedBox(height: 16),

          // Lap records
          if (_laps.isNotEmpty)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListView.separated(
                  itemCount: _laps.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Lap ${_laps.length - index}', style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                          Text(_laps[index], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF5268))),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showProfileModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 34,
              backgroundColor: Color(0xFFFF5268),
              child: Icon(Icons.person, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 14),
            const Text(
              'Fatima Zulfiqar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 4),
            const Text(
              'FA24BCS417 • Sir Jamshed Iqbal (MAD)',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            CoralPillButton(
              text: 'CLOSE',
              width: double.infinity,
              onPressed: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
