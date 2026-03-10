import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';
import '../../../data/models/ambience.dart';

class SessionPlayerScreen extends ConsumerStatefulWidget {
  final Ambience ambience;

  const SessionPlayerScreen({super.key, required this.ambience});

  @override
  ConsumerState<SessionPlayerScreen> createState() =>
      _SessionPlayerScreenState();
}

class _SessionPlayerScreenState extends ConsumerState<SessionPlayerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionState = ref.read(sessionProvider);
      if (sessionState.ambience?.id != widget.ambience.id) {
        ref.read(sessionProvider.notifier).startSession(widget.ambience);
      }
    });
  }

  String _formatTime(int seconds) {
    if (seconds < 0) return '00:00';
    final minuteStr = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondStr = (seconds % 60).toString().padLeft(2, '0');
    return '$minuteStr:$secondStr';
  }

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

  void _showEndDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(36),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 40,
                      offset: const Offset(0, 20),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.spa_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'End Session?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ready to calmly close this session and reflect on your thoughts?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 36),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        ref.read(sessionProvider.notifier).endSessionFromTimer();
                        context.go('/journal', extra: widget.ambience);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'End & Reflect',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Continue Listening',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        final curvedValue = Curves.easeOutCubic.transform(anim1.value);
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20 * curvedValue, sigmaY: 20 * curvedValue),
          child: Transform.scale(
            scale: 0.95 + (0.05 * curvedValue),
            child: Opacity(
              opacity: anim1.value,
              child: child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final isPlaying = session.isPlaying;
    final elapsed = session.elapsedSeconds;
    final duration = widget.ambience.durationSeconds;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    ref.listen(sessionProvider, (prev, next) {
      if (next.elapsedSeconds >= duration && next.ambience != null) {
        context.go('/journal', extra: next.ambience);
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 28),
                        onPressed: () => context.pop(),
                      ),
                      Text(
                        'NOW PLAYING',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),

                  const Spacer(flex: 1),

                  Container(
                    height: screenHeight * 0.32,
                    width: screenHeight * 0.32,
                    constraints: BoxConstraints(
                      maxWidth: screenWidth * 0.8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        )
                      ],
                    ),
                    child: Hero(
                      tag: 'hero-image-${widget.ambience.id}',
                      child: Material(
                        type: MaterialType.transparency,
                        borderRadius: BorderRadius.circular(24),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          _getImagePath(widget.ambience.title),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  Text(
                    widget.ambience.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.ambience.tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Spacer(flex: 2),

                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.15),
                      thumbColor: Colors.white,
                      trackHeight: 3.0,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
                    ),
                    child: Slider(
                      value: elapsed.toDouble().clamp(0, duration.toDouble()),
                      max: duration.toDouble(),
                      onChanged: (val) {
                        ref.read(sessionProvider.notifier).seekTo(val);
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(elapsed),
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                        ),
                        Text(
                          _formatTime(duration),
                          style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.replay_10),
                        color: Colors.white.withOpacity(0.6),
                        onPressed: () {
                          final newTime = (elapsed - 10).clamp(0, duration);
                          ref.read(sessionProvider.notifier).seekTo(newTime.toDouble());
                        },
                      ),
                      const SizedBox(width: 32),
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              )
                            ]
                        ),
                        child: IconButton(
                          iconSize: 44,
                          icon: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          ),
                          color: Colors.black,
                          padding: const EdgeInsets.all(12),
                          onPressed: () {
                            ref.read(sessionProvider.notifier).togglePlayPause();
                          },
                        ),
                      ),
                      const SizedBox(width: 32),
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(Icons.forward_10),
                        color: Colors.white.withOpacity(0.6),
                        onPressed: () {
                          final newTime = (elapsed + 10).clamp(0, duration);
                          ref.read(sessionProvider.notifier).seekTo(newTime.toDouble());
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  TextButton.icon(
                    onPressed: _showEndDialog,
                    icon: Icon(Icons.stop_circle_outlined, color: Colors.white.withOpacity(0.4), size: 20),
                    label: Text(
                      'End Session',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}