import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/ambience.dart';
import '../../../data/models/reflection.dart';
import '../../../main.dart';

class ReflectionScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const ReflectionScreen({super.key, required this.ambience});

  @override
  ConsumerState<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends ConsumerState<ReflectionScreen> {
  final _controller = TextEditingController();

  final List<Map<String, String>> moods = [
    {'label': 'Calm', 'icon': '🌿'},
    {'label': 'Grounded', 'icon': '🪨'},
    {'label': 'Energized', 'icon': '⚡'},
    {'label': 'Sleepy', 'icon': '🌙'},
  ];

  String? _selectedMood;

  String _getImagePath(String title) {
    final t = title.toLowerCase();
    if (t.contains('forest')) return 'assets/images/forest.webp';
    if (t.contains('ocean')) return 'assets/images/ocean.webp';
    if (t.contains('evening')) return 'assets/images/evening.webp';
    if (t.contains('sleep')) return 'assets/images/sleep.webp';
    if (t.contains('cafe')) return 'assets/images/cafe.webp';
    if (t.contains('morning')) return 'assets/images/morning.webp';
    return 'assets/images/forest.webp';
  }

  String _getDynamicPrompt() {
    switch (_selectedMood) {
      case 'Calm':
        return 'What brought you this sense of calm?';
      case 'Grounded':
        return 'What is keeping you feeling grounded?';
      case 'Energized':
        return 'What are you excited to focus this energy on?';
      case 'Sleepy':
        return 'Drop any lingering thoughts here before you rest... ';
      default:
        return 'Jot down whatever is on your mind...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isReadyToSave = _selectedMood != null;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 18),
          ),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Image.asset(
                _getImagePath(widget.ambience.title),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    const Color(0xFF050505),
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),

          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.ambience.title} Complete',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        const Text(
                          'How are you feeling?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: moods.map((moodObj) {
                            final mood = moodObj['label']!;
                            final icon = moodObj['icon']!;
                            final isSelected = _selectedMood == mood;

                            return GestureDetector(
                              onTap: () => setState(() => _selectedMood = mood),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(icon, style: const TextStyle(fontSize: 14)),
                                    const SizedBox(width: 8),
                                    Text(
                                      mood,
                                      style: TextStyle(
                                        color: isSelected ? Colors.black : Colors.white70,
                                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 48),

                        Text(
                          _selectedMood == null ? 'Describe your thoughts' : 'Add a Journal Note',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 5,
                            minLines: 4,
                            onChanged: (_) => setState(() {}),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              height: 1.5,
                            ),
                            decoration: InputDecoration(
                              hintText: _getDynamicPrompt(),
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 15,
                              ),
                              contentPadding: const EdgeInsets.all(20),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.fromLTRB(
                    24,
                    16,
                    24,
                    bottomInset > 0 ? bottomInset + 16 : MediaQuery.of(context).padding.bottom + 24
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF050505).withOpacity(0.0),
                      const Color(0xFF050505),
                    ],
                  ),
                ),
                child: GestureDetector(
                  onTap: isReadyToSave ? () async {
                    String finalNote = _controller.text.trim();
                    if (finalNote.isEmpty) {
                      finalNote = 'Rested in the moment.';
                    }

                    final reflection = Reflection(
                      id: const Uuid().v4(),
                      dateTime: DateTime.now(),
                      ambienceId: widget.ambience.id,
                      ambienceTitle: widget.ambience.title,
                      mood: _selectedMood!,
                      journalText: finalNote,
                    );

                    final repo = ref.read(reflectionRepoProvider);
                    await repo.saveReflection(reflection);
                    if (context.mounted) {
                      context.go('/history');
                    }
                  } : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: isReadyToSave ? Colors.white : Colors.white.withOpacity(0.05),
                      boxShadow: isReadyToSave ? [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        )
                      ] : [],
                    ),
                    child: Center(
                      child: Text(
                        'Save Reflection',
                        style: TextStyle(
                          color: isReadyToSave ? Colors.black : Colors.white.withOpacity(0.3),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}