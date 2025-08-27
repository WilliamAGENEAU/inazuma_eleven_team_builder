class Saga {
  final String id;
  final String name;

  Saga({required this.id, required this.name});

  factory Saga.fromFirestore(Map<String, dynamic> data, String id) {
    return Saga(id: id, name: data['name'] ?? '');
  }
}
