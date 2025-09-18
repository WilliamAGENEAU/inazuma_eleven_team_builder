// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class TeamHeader extends StatelessWidget {
  final String selectedFormation;
  final String? selectedCoach;
  final String? selectedMaillot;
  final String? selectedEcusson;
  final List<String> formations;
  final Function(String) onFormationChanged;
  final VoidCallback onOpenCoachSelector;
  final VoidCallback onOpenMaillotSelector;
  final VoidCallback onOpenClubSelector;
  final VoidCallback onToggleMenu;
  final VoidCallback onResetTeam;

  const TeamHeader({
    super.key,
    required this.selectedFormation,
    required this.selectedCoach,
    required this.selectedMaillot,
    required this.selectedEcusson,
    required this.formations,
    required this.onFormationChanged,
    required this.onOpenCoachSelector,
    required this.onOpenMaillotSelector,
    required this.onOpenClubSelector,
    required this.onToggleMenu,
    required this.onResetTeam,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return SliverAppBar(
      floating: true,
      pinned: true,
      expandedHeight: 140,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            children: [
              // === AppBar (menu + logo + reset) ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: onToggleMenu,
                  ),
                  // === LOGO TEAM BUILDER ===
                  Image.asset(
                    "assets/images/team_builder_logo.png",
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black),
                    tooltip: "Reset l'équipe",
                    onPressed: onResetTeam,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // === Ligne selectors Formation / Coach / Maillot / Écusson ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Formation
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        value: selectedFormation,
                        items: formations
                            .map(
                              (f) => DropdownMenuItem(
                                value: f,
                                child: Text(
                                  f,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            onFormationChanged(value ?? formations.first),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Coach
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpenCoachSelector,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              if (selectedCoach != null &&
                                  selectedCoach!.isNotEmpty)
                                Image.asset(
                                  selectedCoach!,
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                              else
                                const Icon(
                                  Icons.person,
                                  size: 38,
                                  color: Colors.black87,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Maillot
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpenMaillotSelector,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              if (selectedMaillot != null &&
                                  selectedMaillot!.isNotEmpty)
                                Image.asset(
                                  selectedMaillot!,
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                              else
                                const Icon(
                                  Icons.checkroom,
                                  size: 38,
                                  color: Colors.black87,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Écusson
                    Expanded(
                      child: GestureDetector(
                        onTap: onOpenClubSelector,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              if (selectedEcusson != null &&
                                  selectedEcusson!.isNotEmpty)
                                Image.asset(
                                  selectedEcusson!,
                                  height: 50,
                                  fit: BoxFit.contain,
                                )
                              else
                                const Icon(
                                  Icons.shield,
                                  size: 38,
                                  color: Colors.black87,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
