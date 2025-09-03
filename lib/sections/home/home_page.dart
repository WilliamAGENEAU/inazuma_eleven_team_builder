// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/joueur.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/club_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/coach_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/hex_buttons.dart';
import 'package:inazuma_eleven_team_builder/widget/maillot_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/menu_aside.dart';
import 'package:inazuma_eleven_team_builder/widget/player_selector_bottom_sheet.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class HomePage extends StatefulWidget {
  static const String homePageRoute = StringConst.HOME_PAGE;

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isOpened = false;
  String selectedFormation = "4-3-3";
  String? selectedEcusson;
  String? selectedCoach;
  String? selectedMaillot;
  List<Joueur?> hexPlayers = List.filled(11, null);
  List<Joueur?> remplacants = List.filled(5, null);

  final List<String> formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"];

  /// Positions sur le terrain
  final Map<String, List<Offset>> formationPositions = {
    "4-3-3": [
      Offset(0.5, 0.875), // Gardien
      Offset(0.2, 0.75), Offset(0.4, 0.75),
      Offset(0.6, 0.75), Offset(0.8, 0.75), // Défense
      Offset(0.2, 0.6), Offset(0.5, 0.6), Offset(0.8, 0.6), // Milieu
      Offset(0.2, 0.45), Offset(0.5, 0.4), Offset(0.8, 0.45), // Attaque
    ],
    "4-4-2": [
      Offset(0.5, 0.875), // Gardien
      Offset(0.2, 0.75), Offset(0.4, 0.75),
      Offset(0.6, 0.75), Offset(0.8, 0.75), // Défense
      Offset(0.2, 0.6),
      Offset(0.4, 0.6),
      Offset(0.6, 0.6),
      Offset(0.8, 0.6), // Milieu
      Offset(0.4, 0.45), Offset(0.6, 0.45), // Attaque
    ],
    "3-5-2": [
      Offset(0.5, 0.875), // Gardien
      Offset(0.3, 0.75), Offset(0.5, 0.75), Offset(0.7, 0.75), //Défense
      Offset(0.15, 0.6),
      Offset(0.4, 0.6),
      Offset(0.6, 0.6),
      Offset(0.85, 0.6), // Milieu
      Offset(0.5, 0.5),
      Offset(0.4, 0.4), Offset(0.6, 0.4), // Attaque
    ],
    "5-3-2": [
      Offset(0.5, 0.875), // Gardien
      Offset(0.15, 0.7),
      Offset(0.3, 0.75), Offset(0.5, 0.75),
      Offset(0.7, 0.75), Offset(0.85, 0.7), // Défense
      Offset(0.2, 0.6), Offset(0.5, 0.6), Offset(0.8, 0.6), // Milieu
      Offset(0.4, 0.45), Offset(0.6, 0.45), // Attaque
    ],
  };

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
    void openCoachSelector() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => CoachSelectorBottomSheet(
          onCoachSelected: (coach) {
            setState(() => selectedCoach = coach);
          },
        ),
      );
    }

    void openMaillotSelector() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => MaillotSelectorBottomSheet(
          onMaillotSelected: (maillot) {
            setState(() => selectedMaillot = maillot);
          },
        ),
      );
    }

    void openClubSelector() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ClubSelectorBottomSheet(
          onEcussonSelected: (club) {
            setState(() => selectedEcusson = club);
          },
        ),
      );
    }

    void toggleMenu() {
      final state = sideMenuKey.currentState!;
      state.isOpened ? state.closeSideMenu() : state.openSideMenu();
    }

    final gradient = const LinearGradient(
      colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return SideMenu(
      key: sideMenuKey,
      background: AppColors.white,
      type: SideMenuType.shrinkNSlide,
      menu: MenuAside(
        context,
        closeMenu: () => sideMenuKey.currentState?.closeSideMenu(),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              /// Fond terrain
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(ImagePath.FIELD, fit: BoxFit.cover),
                ),
              ),

              /// Joueurs titulaires (hexagones animés)
              ...formationPositions[selectedFormation]!.asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final pos = entry.value;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutBack,
                  left: MediaQuery.of(context).size.width * pos.dx - 30,
                  top: MediaQuery.of(context).size.height * pos.dy - 120,
                  child: AnimatedScale(
                    scale: hexPlayers[index] == null ? 0.9 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: HexButton(
                      joueur: hexPlayers[index],
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => PlayerSelectorBottomSheet(
                            onPlayerSelected: (joueur) {
                              setState(() => hexPlayers[index] = joueur);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),

              /// Remplaçants
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(remplacants.length, (index) {
                      return HexButton(
                        joueur: remplacants[index],
                        isRemplacant: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => PlayerSelectorBottomSheet(
                              onPlayerSelected: (joueur) {
                                setState(() => remplacants[index] = joueur);
                              },
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),

              /// AppBar/Menu avec gradient Victory Road
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () => toggleMenu(),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Team Builder",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              /// Ligne de sélection Formation / Coach / Écusson / Maillot
              Positioned(
                top: kToolbarHeight + 16,
                left: 12,
                right: 12,
                child: Container(
                  width: double.infinity, // 🔥 prend toute la largeur
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Dropdown Formation
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
                              setState(() => selectedFormation = value!),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Coach
                      Expanded(
                        child: GestureDetector(
                          onTap: openCoachSelector,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 28,
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
                          onTap: openMaillotSelector,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                if (selectedMaillot != null &&
                                    selectedMaillot!.isNotEmpty)
                                  Image.asset(
                                    selectedMaillot!,
                                    height: 36,
                                    fit: BoxFit.contain,
                                  )
                                else
                                  const Icon(
                                    Icons.checkroom,
                                    size: 28,
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
                          onTap: openClubSelector,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Column(
                              children: [
                                if (selectedEcusson != null &&
                                    selectedEcusson!.isNotEmpty)
                                  Image.asset(
                                    selectedEcusson!,
                                    height: 36,
                                    fit: BoxFit.contain,
                                  )
                                else
                                  const Icon(
                                    Icons.shield,
                                    size: 28,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
