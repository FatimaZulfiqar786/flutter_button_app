import 'package:flutter/material.dart';
import '../widgets/coral_pill_button.dart';

class SoundPickerScreen extends StatefulWidget {
  final String currentSound;

  const SoundPickerScreen({
    super.key,
    required this.currentSound,
  });

  @override
  State<SoundPickerScreen> createState() => _SoundPickerScreenState();
}

class _SoundPickerScreenState extends State<SoundPickerScreen>
    with SingleTickerProviderStateMixin {
  late String _selectedSound;
  String? _playingSound;
  late AnimationController _waveController;

  static const List<Map<String, dynamic>> availableSounds = [
    {
      'title': 'Jungle Morning',
      'desc': 'Gentle birds chirping and morning breeze',
      'duration': '0:30',
    },
    {
      'title': 'Ceramic',
      'desc': 'Soft melodic acoustic chime notes',
      'duration': '0:24',
    },
    {
      'title': 'Rooster Crow',
      'desc': 'Classic morning wakeup rooster call',
      'duration': '0:18',
    },
    {
      'title': 'Ocean Breeze',
      'desc': 'Calming rhythmic ocean waves',
      'duration': '0:45',
    },
    {
      'title': 'Electric Bell',
      'desc': 'Crisp electronic digital bell sequence',
      'duration': '0:20',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.currentSound;
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onSoundTapped(String title) {
    setState(() {
      _selectedSound = title;
      _playingSound = title;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing preview: $title'),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFFFF5268),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _onSave() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    Navigator.pop(context, _selectedSound);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Alarm Sound Picker',
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: CoralPillButton(
              text: 'SAVE',
              height: 38,
              fontSize: 12,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: _onSave,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: availableSounds.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF1F5F9),
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final sound = availableSounds[index];
                  final title = sound['title'] as String;
                  final desc = sound['desc'] as String;
                  final isSelected = title == _selectedSound;
                  final isPlaying = title == _playingSound;

                  return Material(
                    color: isSelected
                        ? const Color(0xFFFF5268).withOpacity(0.04)
                        : Colors.transparent,
                    child: InkWell(
                      onTap: () => _onSoundTapped(title),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            // Icon or selection indicator
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFFFF5268)
                                    : const Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isPlaying
                                    ? Icons.volume_up_rounded
                                    : Icons.music_note_rounded,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF94A3B8),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Sound title and description
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: isSelected
                                          ? const Color(0xFFFF5268)
                                          : const Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    desc,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Playing animation indicator or checkmark
                            if (isSelected)
                              AnimatedBuilder(
                                animation: _waveController,
                                builder: (context, child) {
                                  return Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 12 + (_waveController.value * 10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF5268),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Container(
                                        width: 3,
                                        height: 18 - (_waveController.value * 8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF5268),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Container(
                                        width: 3,
                                        height: 10 + (_waveController.value * 12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF5268),
                                          borderRadius: BorderRadius.circular(2),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: Color(0xFFFF5268),
                                        size: 22,
                                      ),
                                    ],
                                  );
                                },
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
        ),
      ),
    );
  }
}
