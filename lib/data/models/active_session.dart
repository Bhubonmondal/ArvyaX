import 'package:hive/hive.dart';

part 'active_session.g.dart';

@HiveType(typeId: 1)
class ActiveSession extends HiveObject {
  @HiveField(0)
  final String ambienceId;

  @HiveField(1)
  final int elapsedSeconds;

  @HiveField(2)
  final bool isPlaying;

  ActiveSession({
    required this.ambienceId,
    required this.elapsedSeconds,
    required this.isPlaying,
  });
}
