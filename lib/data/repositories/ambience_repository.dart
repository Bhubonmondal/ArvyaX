import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/ambience.dart';

class AmbienceRepository {
  Future<List<Ambience>> getAmbiences() async {
    final String response = await rootBundle.loadString(
      'assets/data/ambiences.json',
    );
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Ambience.fromJson(json)).toList();
  }
}
