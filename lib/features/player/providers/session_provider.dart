import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/active_session.dart';
import '../../../data/models/ambience.dart';
import '../../../main.dart'; // for sessionRepoProvider
import 'audio_provider.dart';

class SessionState {
  final Ambience? ambience;
  final int elapsedSeconds;
  final bool isPlaying;

  SessionState({
    this.ambience,
    this.elapsedSeconds = 0,
    this.isPlaying = false,
  });

  SessionState copyWith({
    Ambience? ambience,
    int? elapsedSeconds,
    bool? isPlaying,
  }) {
    return SessionState(
      ambience: ambience ?? this.ambience,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

class SessionNotifier extends Notifier<SessionState> {
  Timer? _timer;

  @override
  SessionState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return SessionState();
  }

  void startSession(Ambience ambience) async {
    state = SessionState(
      ambience: ambience,
      elapsedSeconds: 0,
      isPlaying: true,
    );

    // Start Audio
    final player = ref.read(audioPlayerProvider);
    await player.setAsset(ambience.audioAssetPath);
    await player.setLoopMode(LoopMode.one);
    player.play();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isPlaying) {
        final newElapsed = state.elapsedSeconds + 1;
        state = state.copyWith(elapsedSeconds: newElapsed);

        // Auto end session handling could go here or in UI
        if (newElapsed >= ambience.durationSeconds) {
          endSessionFromTimer();
        } else {
          _saveState();
        }
      }
    });
  }

  void togglePlayPause() {
    final player = ref.read(audioPlayerProvider);
    if (state.isPlaying) {
      player.pause();
      state = state.copyWith(isPlaying: false);
    } else {
      player.play();
      state = state.copyWith(isPlaying: true);
    }
    _saveState();
  }

  void seekTo(double seconds) {
    state = state.copyWith(elapsedSeconds: seconds.toInt());
    _saveState();
  }

  Future<void> endSessionFromTimer() async {
    _timer?.cancel();
    final player = ref.read(audioPlayerProvider);
    await player.stop();
    state = state.copyWith(isPlaying: false);

    final repo = ref.read(sessionRepoProvider);
    await repo.clearSession();
  }

  Future<void> restoreSession(Ambience ambience, int elapsed) async {
    state = SessionState(
      ambience: ambience,
      elapsedSeconds: elapsed,
      isPlaying: false,
    );
  }

  void _saveState() {
    if (state.ambience != null) {
      final repo = ref.read(sessionRepoProvider);
      repo.saveSession(
        ActiveSession(
          ambienceId: state.ambience!.id,
          elapsedSeconds: state.elapsedSeconds,
          isPlaying: state.isPlaying,
        ),
      );
    }
  }
}

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(
  SessionNotifier.new,
);
