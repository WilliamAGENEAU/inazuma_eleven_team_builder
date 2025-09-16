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
        .map((d) => Joueur.fromFirestore(d.data(), d.id))
        .toList();
  }

  /// Récupère toutes les équipes de toutes les sagas (à plat)
  Future<List<Equipe>> getAllEquipes() async {
    final sagasSnap = await _firestore.collection('sagas').get();
    final List<Equipe> out = [];
    for (final sagaDoc in sagasSnap.docs) {
      final eqSnap = await _firestore
          .collection('sagas')
          .doc(sagaDoc.id)
          .collection('equipes')
          .get();
      out.addAll(eqSnap.docs.map((d) => Equipe.fromFirestore(d.data(), d.id)));
    }
    return out;
  }

  /// Permet de retrouver la saga d’une équipe (utile quand on filtre “par équipe”)
  Future<String?> getSagaIdByEquipeId(String equipeId) async {
    final sagasSnap = await _firestore.collection('sagas').get();
    for (final sagaDoc in sagasSnap.docs) {
      final eq = await _firestore
          .collection('sagas')
          .doc(sagaDoc.id)
          .collection('equipes')
          .doc(equipeId)
          .get();
      if (eq.exists) return sagaDoc.id;
    }
    return null;
  }

  /// Liste de tous les coachs disponibles (nullable filtrés)
  Future<List<String>> getAllCoachs() async {
    final equipes = await getAllEquipes();
    return equipes
        .map((e) => e.coach)
        .where((c) => c != null && c.isNotEmpty)
        .cast<String>()
        .toList();
  }

  Future<List<Map<String, String>>> getAllMaillots() async {
    final equipes = await getAllEquipes();
    return equipes.map((e) {
      return {
        "team": e.name,
        "maillot": e.maillot ?? "", // 🔥 valeur par défaut
        "ecusson": e.image, // 🔥 valeur par défaut
      };
    }).toList();
  }

  Future<String?> getEcussonByEquipeId(String equipeId, String sagaId) async {
    final doc = await _firestore
        .collection('sagas')
        .doc(sagaId)
        .collection('equipes')
        .doc(equipeId)
        .get();

    if (!doc.exists) return null;
    final data = doc.data();
    return data?['image']; // ⚽ champ ecusson
  }
}
