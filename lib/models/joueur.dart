class Joueur {
  final String id;
  final String name;
  final String poste;
  final String type;
  final String icon;
  final List<String> techniques;
  final String equipeId; // Id de l'équipe dans Firestore
  final String? equipeEcusson; // Path image de l’écusson

  Joueur({
    required this.id,
    required this.name,
    required this.poste,
    required this.type,
    required this.icon,
    required this.techniques,
    required this.equipeId,
    this.equipeEcusson,
  });

  factory Joueur.fromFirestore(Map<String, dynamic> map, String id) {
    return Joueur(
      id: id,
      name: map['name'] ?? '',
      poste: map['poste'] ?? '',
      type: map['type'] ?? '',
      icon: map['icon'] ?? '',
      techniques: List<String>.from(map['techniques'] ?? []),
      equipeId: map['equipeId'] ?? '',
      equipeEcusson: map['ecusson'],
    ); // ⚡ stocké direct en Firestore    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon,
      'equipeId': equipeId,
      'equipeEcusson': equipeEcusson,
    };
  }
}
