class Equipe {
  final String id;
  final String name;
  final String image;
  final String? maillot;
  final String? coach;

  Equipe({
    required this.id,
    required this.name,
    this.coach,
    this.maillot,
    required this.image,
  });

  factory Equipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Equipe(
      id: id,
      name: data['name'] ?? '',
      image: data['image'],
      maillot: data['maillot'],
      coach: data['coach'],
    );
  }
}
