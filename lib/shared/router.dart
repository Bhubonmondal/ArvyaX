import 'package:go_router/go_router.dart';
import '../data/models/ambience.dart';
import '../features/player/screens/session_player_screen.dart';
import '../features/journal/screens/reflection_screen.dart';
import '../features/journal/screens/history_screen.dart';
import '../features/ambience/screens/home_screen.dart' hide AmbienceDetailsScreen;
import '../features/ambience/screens/ambience_details_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/details',
      builder: (context, state) =>
          AmbienceDetailsScreen(ambience: state.extra as Ambience),
    ),
    GoRoute(
      path: '/player',
      builder: (context, state) =>
          SessionPlayerScreen(ambience: state.extra as Ambience),
    ),
    GoRoute(
      path: '/journal',
      builder: (context, state) =>
          ReflectionScreen(ambience: state.extra as Ambience),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
  ],
);
