import 'package:hive_flutter/hive_flutter.dart';
import '../models/active_session.dart';

class SessionRepository {
  static const String _boxName = 'active_session_box';
  static const String _key = 'current_session';

  Future<void> init() async {
    await Hive.openBox<ActiveSession>(_boxName);
  }

  Future<void> saveSession(ActiveSession session) async {
    final box = Hive.box<ActiveSession>(_boxName);
    await box.put(_key, session);
  }

  ActiveSession? getSession() {
    if (!Hive.isBoxOpen(_boxName)) return null;
    final box = Hive.box<ActiveSession>(_boxName);
    return box.get(_key);
  }

  Future<void> clearSession() async {
    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<ActiveSession>(_boxName);
    await box.delete(_key);
  }
}
