// lib/models/technique.dart
class Technique {
  final String id;
  final String name;
  final String url;
  final String poste;

  Technique({
    required this.id,
    required this.name,
    required this.url,
    required this.poste,
  });

  factory Technique.fromFirestore(Map<String, dynamic> data, String id) {
    return Technique(
      id: id,
      name: data['name'] ?? '',
      url: data['url'] ?? '',
      poste: data['poste'] ?? '',
    );
  }
}
