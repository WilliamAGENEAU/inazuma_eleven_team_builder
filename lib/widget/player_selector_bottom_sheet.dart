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
    setState(() => sagas = data);
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (selectedSaga == null) {
      /// Étape 1 : choisir la saga
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: sagas.length,
        itemBuilder: (context, index) {
          final saga = sagas[index];
          return GestureDetector(
            onTap: () => _loadEquipes(saga),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                saga.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      );
    } else if (selectedEquipe == null) {
      /// Étape 2 : choisir l’équipe
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemCount: equipes.length,
        itemBuilder: (context, index) {
          final equipe = equipes[index];
          return GestureDetector(
            onTap: () => _loadJoueurs(equipe),
            child: Column(
              children: [
                Expanded(
                  child: ClipPath(
                    clipper: HexagonClipper(),
                    child: Container(
                      color: Colors.grey[700],
                      child: Image.asset(equipe.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  equipe.name,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        },
      );
    } else {
      /// Étape 3 : choisir le joueur
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
                child: Image.asset(joueur.icon, fit: BoxFit.cover),
              ),
            ),
          );
        },
      );
    }
  }
}
