class Saga {
  final String id;
  final String name;
  final String image;

  Saga({required this.id, required this.name, required this.image});

  factory Saga.fromFirestore(Map<String, dynamic> data, String id) {
    return Saga(id: id, name: data['name'] ?? '', image: data['image'] ?? '');
  }
}
