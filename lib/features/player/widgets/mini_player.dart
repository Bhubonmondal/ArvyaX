import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/session_provider.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);

    if (session.ambience == null) return const SizedBox.shrink();

    final isPlaying = session.isPlaying;
    final ambience = session.ambience!;
    final progress = ambience.durationSeconds > 0
        ? session.elapsedSeconds / ambience.durationSeconds
        : 0.0;

    return SafeArea(
      top: false,
      child: GestureDetector(
        onTap: () {
          context.push('/player', extra: ambience);
        },
        child: Container(
          height: 64,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          decoration: BoxDecoration(
            color: const Color(0xFF18181C),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.transparent,
                  color: Colors.white.withOpacity(0.8),
                  minHeight: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        _getImagePath(ambience.title),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ambience.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ambience.tag,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        ref.read(sessionProvider.notifier).togglePlayPause();
                      },
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