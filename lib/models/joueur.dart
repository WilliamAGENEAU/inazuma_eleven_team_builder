import 'package:inazuma_eleven_team_builder/models/techniques.dart';

class Joueur {
  final String id;
  final String name;
  final String poste;
  final String type;
  final String icon;
  final String? equipeEcusson;
  List<Technique> techniques;

  Joueur({
    required this.id,
    required this.name,
    required this.poste,
    required this.type,
    required this.icon,
    this.equipeEcusson,
    this.techniques = const [],
  });

  factory Joueur.fromFirestore(
    Map<String, dynamic> data,
    String id,
    List<Technique> techniques,
  ) {
    return Joueur(
      id: id,
      name: data['name'] ?? '',
      poste: data['poste'] ?? '',
      type: data['type'] ?? '',
      icon: data['icon'] ?? '',
      equipeEcusson: data['ecusson'],
      techniques: techniques,
    );
  }
}
