// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../services/firebase_service.dart';

class MaillotSelectorBottomSheet extends StatefulWidget {
  final Function(String) onMaillotSelected;

  const MaillotSelectorBottomSheet({
    super.key,
    required this.onMaillotSelected,
  });

  @override
  State<MaillotSelectorBottomSheet> createState() =>
      _MaillotSelectorBottomSheetState();
}

class _MaillotSelectorBottomSheetState
    extends State<MaillotSelectorBottomSheet> {
  final FirebaseService _firebaseService = FirebaseService();
  List<Map<String, String>> maillots = [];

  @override
  void initState() {
    super.initState();
    _loadMaillots();
  }

  void _loadMaillots() async {
    final data = await _firebaseService.getAllMaillots();
    setState(() => maillots = data);
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
        child: maillots.isEmpty
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: maillots.length,
                itemBuilder: (context, index) {
                  final item = maillots[index];
                  final maillot = item["maillot"];
                  final team = item["team"];
                  final ecusson = item["ecusson"];

                  // ⚡ gestion si Firestore n'a pas de maillot
                  if (maillot == null || maillot.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return GestureDetector(
                    onTap: () {
                      widget.onMaillotSelected(maillot);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (maillot.isNotEmpty)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  maillot,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (ecusson != null && ecusson.isNotEmpty)
                                Image.asset(ecusson, width: 24, height: 24),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  team ?? "Équipe inconnue",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
