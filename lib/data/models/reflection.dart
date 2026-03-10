import 'package:hive/hive.dart';

part 'reflection.g.dart';

@HiveType(typeId: 0)
class Reflection extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime dateTime;

  @HiveField(2)
  final String ambienceId;

  @HiveField(3)
  final String ambienceTitle;

  @HiveField(4)
  final String mood;

  @HiveField(5)
  final String journalText;

  Reflection({
    required this.id,
    required this.dateTime,
    required this.ambienceId,
    required this.ambienceTitle,
    required this.mood,
    required this.journalText,
  });
}
