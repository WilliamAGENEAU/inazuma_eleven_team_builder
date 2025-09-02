class Joueur {
  final String id;
  final String name;
  final String poste;
  final String type;
  final String icon;
  final List<String> techniques;

  Joueur({
    required this.id,
    required this.name,
    required this.poste,
    required this.type,
    required this.icon,
    required this.techniques,
  });

  factory Joueur.fromFirestore(Map<String, dynamic> map, String id) {
    return Joueur(
      id: id,
      name: map['name'] ?? '',
      poste: map['poste'] ?? '',
      type: map['type'] ?? '',
      icon: map['icon'] ?? '',
      techniques: List<String>.from(map['techniques'] ?? []),
    );
  }
}
