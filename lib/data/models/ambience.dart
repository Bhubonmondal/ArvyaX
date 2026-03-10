class Ambience {
  final String id;
  final String title;
  final String tag;
  final int durationSeconds;
  final String description;
  final List<String> sensoryChips;
  final String audioAssetPath;
  final String thumbnailAssetPath;

  const Ambience({
    required this.id,
    required this.title,
    required this.tag,
    required this.durationSeconds,
    required this.description,
    required this.sensoryChips,
    required this.audioAssetPath,
    required this.thumbnailAssetPath,
  });

  factory Ambience.fromJson(Map<String, dynamic> json) {
    return Ambience(
      id: json['id'] as String,
      title: json['title'] as String,
      tag: json['tag'] as String,
      durationSeconds: json['durationSeconds'] as int,
      description: json['description'] as String,
      sensoryChips: List<String>.from(json['sensoryChips']),
      audioAssetPath: json['audioAssetPath'] as String,
      thumbnailAssetPath: json['thumbnailAssetPath'] as String,
    );
  }
}
