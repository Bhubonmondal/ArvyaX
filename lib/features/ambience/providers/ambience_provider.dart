import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ambience.dart';
import '../../../data/repositories/ambience_repository.dart';

final ambienceRepositoryProvider = Provider<AmbienceRepository>((ref) {
  return AmbienceRepository();
});

final ambiencesProvider = FutureProvider<List<Ambience>>((ref) async {
  final repo = ref.watch(ambienceRepositoryProvider);
  return repo.getAmbiences();
});

class SearchNotifier extends Notifier<String> {
  @override
  String build() => '';
  void updateQuery(String q) => state = q;
}

final searchProvider = NotifierProvider<SearchNotifier, String>(
  SearchNotifier.new,
);

class TagNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void toggle(String tag) {
    if (state == tag) {
      state = null;
    } else {
      state = tag;
    }
  }

  void clear() => state = null;
}

final selectedTagProvider = NotifierProvider<TagNotifier, String?>(
  TagNotifier.new,
);

final filteredAmbiencesProvider = Provider<List<Ambience>>((ref) {
  final ambiencesAsync = ref.watch(ambiencesProvider);
  final searchQuery = ref.watch(searchProvider).toLowerCase();
  final selectedTag = ref.watch(selectedTagProvider);

  return ambiencesAsync.maybeWhen(
    data: (ambiences) {
      return ambiences.where((amb) {
        final matchesSearch = amb.title.toLowerCase().contains(searchQuery);
        final matchesTag = selectedTag == null || amb.tag == selectedTag;
        return matchesSearch && matchesTag;
      }).toList();
    },
    orElse: () => [],
  );
});
