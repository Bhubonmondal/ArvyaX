import 'package:hive_flutter/hive_flutter.dart';
import '../models/reflection.dart';

class ReflectionRepository {
  late Box<Reflection> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Reflection>('reflections');
  }

  List<Reflection> getReflections() {
    return _box.values.toList();
  }

  Future<void> saveReflection(Reflection reflection) async {
    await _box.put(reflection.id, reflection);
  }

  Future<void> deleteReflection(String id) async {
    await _box.delete(id);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
}