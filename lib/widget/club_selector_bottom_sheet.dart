// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/equipe.dart';
import '../services/firebase_service.dart';

class ClubSelectorBottomSheet extends StatefulWidget {
  final Function(String) onEcussonSelected;

  const ClubSelectorBottomSheet({super.key, required this.onEcussonSelected});

  @override
  State<ClubSelectorBottomSheet> createState() =>
      _ClubSelectorBottomSheetState();
}

class _ClubSelectorBottomSheetState extends State<ClubSelectorBottomSheet> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Equipe> equipes = [];

  @override
  void initState() {
    super.initState();
    _loadEquipes();
  }

  void _loadEquipes() async {
    final data = await _firebaseService
        .getAllEquipes(); // ⚡ besoin méthode qui retourne toutes les équipes
    setState(() => equipes = data);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: equipes.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                itemCount: equipes.length,
                itemBuilder: (context, index) {
                  final equipe = equipes[index];
                  return GestureDetector(
                    onTap: () {
                      widget.onEcussonSelected(equipe.image);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutBack,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(equipe.image, fit: BoxFit.contain),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
