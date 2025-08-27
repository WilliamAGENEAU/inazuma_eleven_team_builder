import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/saga.dart';
import '../models/equipe.dart';
import '../models/joueur.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Saga>> getSagas() async {
    final snapshot = await _firestore.collection('sagas').get();
    return snapshot.docs
        .map((d) => Saga.fromFirestore(d.data(), d.id))
        .toList();
  }

  Future<List<Equipe>> getEquipes(String sagaId) async {
    final snapshot = await _firestore
        .collection('sagas')
        .doc(sagaId)
        .collection('equipes')
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Equipe.fromFirestore(data, doc.id);
    }).toList();
  }

  Future<List<Joueur>> getJoueurs(String sagaId, String equipeId) async {
    final snapshot = await _firestore
        .collection('sagas')
        .doc(sagaId)
        .collection('equipes')
        .doc(equipeId)
        .collection('joueurs')
        .get();
    return snapshot.docs
        .map(
          (d) => Joueur.fromFirestore(d.data(), d.id),
        ) // <-- fromMap utilise storagePath
        .toList();
  }
}
