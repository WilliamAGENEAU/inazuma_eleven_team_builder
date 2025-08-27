class Equipe {
  final String id;
  final String name;
  final String image;

  Equipe({required this.id, required this.name, required this.image});

  factory Equipe.fromFirestore(Map<String, dynamic> data, String id) {
    return Equipe(
      id: id,
      name: data['name'] ?? '',
      image: data['image'] ?? 'assets/images/default.png',
    );
  }
}
