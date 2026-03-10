import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/reflection.dart';
import 'data/models/active_session.dart';
import 'data/repositories/reflection_repository.dart';
import 'data/repositories/session_repository.dart';
import 'shared/theme/app_theme.dart';
import 'shared/router.dart';

final reflectionRepoProvider = Provider<ReflectionRepository>((ref) {
  return ReflectionRepository();
});

final sessionRepoProvider = Provider<SessionRepository>((ref) {
  return SessionRepository();
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ReflectionAdapter());
  Hive.registerAdapter(ActiveSessionAdapter());

  final reflectionRepo = ReflectionRepository();
  final sessionRepo = SessionRepository();

  await reflectionRepo.init();
  await sessionRepo.init();

  runApp(
    ProviderScope(
      overrides: [
        reflectionRepoProvider.overrideWithValue(reflectionRepo),
        sessionRepoProvider.overrideWithValue(sessionRepo),
      ],
      child: const ArvyaxApp(),
    ),
  );
}

class ArvyaxApp extends StatelessWidget {
  const ArvyaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ArvyaX Mini',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
    );
  }
}
