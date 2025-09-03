// ignore_for_file: deprecated_member_use

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
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFF0A1F44),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(padding: const EdgeInsets.all(16), child: _buildContent()),
    );
  }

  Widget _buildContent() {
    if (selectedSaga == null) {
      /// Étape 1 : choisir la saga
      return _buildGrid(sagas.length, (index) {
        final saga = sagas[index];
        return GestureDetector(
          onTap: () => _loadEquipes(saga),
          child: _styledCard(
            child: Image.asset(saga.image, fit: BoxFit.contain),
          ),
        );
      });
    } else if (selectedEquipe == null) {
      /// Étape 2 : choisir l’équipe
      return _buildGrid(equipes.length, (index) {
        final equipe = equipes[index];
        return GestureDetector(
          onTap: () => _loadJoueurs(equipe),
          child: Column(
            children: [
              Expanded(
                child: ClipPath(
                  clipper: HexagonClipper(),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF005BBB), Color(0xFF1FAF68)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
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
      });
    } else {
      /// Étape 3 : choisir le joueur
      return _buildGrid(joueurs.length, (index) {
        final joueur = joueurs[index];
        return GestureDetector(
          onTap: () {
            widget.onPlayerSelected(joueur);
            Navigator.pop(context);
          },
          child: ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFF1FAF68)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Image.asset(joueur.icon, fit: BoxFit.cover),
            ),
          ),
        );
      }, crossAxisCount: 4);
    }
  }

  Widget _buildGrid(
    int itemCount,
    Widget Function(int) itemBuilder, {
    int crossAxisCount = 3,
  }) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: 1,
        child: itemBuilder(index),
      ),
    );
  }

  Widget _styledCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF005BBB), Color(0xFF1FAF68)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
