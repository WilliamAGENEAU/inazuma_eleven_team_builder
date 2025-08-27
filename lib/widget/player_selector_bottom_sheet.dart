import 'package:flutter/material.dart';
import '../models/saga.dart';
import '../models/equipe.dart';
import '../models/joueur.dart';
import '../services/firebase_service.dart';
import 'hexagon_clipper.dart';

class PlayerSelectorBottomSheet extends StatefulWidget {
  final Function(Joueur) onPlayerSelected;

  const PlayerSelectorBottomSheet({super.key, required this.onPlayerSelected});

  @override
  State<PlayerSelectorBottomSheet> createState() =>
      _PlayerSelectorBottomSheetState();
}

class _PlayerSelectorBottomSheetState extends State<PlayerSelectorBottomSheet> {
  final FirebaseService _firebaseService = FirebaseService();

  List<Saga> sagas = [];
  List<Equipe> equipes = [];
  List<Joueur> joueurs = [];

  Saga? selectedSaga;
  Equipe? selectedEquipe;

  @override
  void initState() {
    super.initState();
    _loadSagas();
  }

  void _loadSagas() async {
    final data = await _firebaseService.getSagas();
    setState(() {
      sagas = data;
    });
  }

  void _loadEquipes(Saga saga) async {
    final data = await _firebaseService.getEquipes(saga.id);
    setState(() {
      selectedSaga = saga;
      equipes = data;
      joueurs = [];
      selectedEquipe = null;
    });
  }

  void _loadJoueurs(Equipe equipe) async {
    final data = await _firebaseService.getJoueurs(selectedSaga!.id, equipe.id);
    setState(() {
      joueurs = data;
      selectedEquipe = equipe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (selectedSaga == null) {
      // Étape 1 : choisir la saga
      return ListView.builder(
        itemCount: sagas.length,
        itemBuilder: (context, index) {
          final saga = sagas[index];
          return ListTile(
            title: Text(saga.name, style: const TextStyle(color: Colors.white)),
            onTap: () => _loadEquipes(saga),
          );
        },
      );
    } else if (selectedEquipe == null) {
      // Étape 2 : choisir l'équipe
      return ListView.builder(
        itemCount: equipes.length,
        itemBuilder: (context, index) {
          final equipe = equipes[index];
          return ListTile(
            leading: Image.asset(equipe.image, width: 40, height: 40),
            title: Text(
              equipe.name,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () => _loadJoueurs(equipe),
          );
        },
      );
    } else {
      // Étape 3 : choisir le joueur
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: joueurs.length,
        itemBuilder: (context, index) {
          final joueur = joueurs[index];
          return GestureDetector(
            onTap: () {
              widget.onPlayerSelected(joueur);
              Navigator.pop(context);
            },
            child: ClipPath(
              clipper: HexagonClipper(),
              child: Container(
                color: Colors.grey[800],
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(joueur.icon, fit: BoxFit.cover),
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
