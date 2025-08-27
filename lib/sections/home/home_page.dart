// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/joueur.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/formation_dropdown.dart';
import 'package:inazuma_eleven_team_builder/widget/hex_buttons.dart';
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

  List<Joueur?> hexPlayers = List.filled(11, null);
  List<Joueur?> remplacants = List.filled(5, null);

  final List<String> formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"];

  /// Positions sur le terrain
  final Map<String, List<Offset>> formationPositions = {
    "4-3-3": [
      Offset(0.5, 0.9), // Gardien
      Offset(0.2, 0.75), Offset(0.4, 0.75),
      Offset(0.6, 0.75), Offset(0.8, 0.75), // Défense
      Offset(0.2, 0.6), Offset(0.5, 0.6), Offset(0.8, 0.6), // Milieu
      Offset(0.2, 0.45), Offset(0.5, 0.45), Offset(0.8, 0.45), // Attaque
    ],
    "4-4-2": [
      Offset(0.5, 0.9),
      Offset(0.2, 0.7),
      Offset(0.4, 0.7),
      Offset(0.6, 0.7),
      Offset(0.8, 0.7),
      Offset(0.2, 0.5),
      Offset(0.4, 0.5),
      Offset(0.6, 0.5),
      Offset(0.8, 0.5),
      Offset(0.4, 0.3),
      Offset(0.6, 0.3),
    ],
    "3-5-2": [
      Offset(0.5, 0.9),
      Offset(0.3, 0.7),
      Offset(0.5, 0.7),
      Offset(0.7, 0.7),
      Offset(0.2, 0.5),
      Offset(0.4, 0.5),
      Offset(0.6, 0.5),
      Offset(0.8, 0.5),
      Offset(0.5, 0.4),
      Offset(0.4, 0.2),
      Offset(0.6, 0.2),
    ],
    "5-3-2": [
      Offset(0.5, 0.9),
      Offset(0.15, 0.7),
      Offset(0.35, 0.7),
      Offset(0.5, 0.75),
      Offset(0.65, 0.7),
      Offset(0.85, 0.7),
      Offset(0.35, 0.5),
      Offset(0.5, 0.5),
      Offset(0.65, 0.5),
      Offset(0.4, 0.3),
      Offset(0.6, 0.3),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

    void toggleMenu() {
      final state = sideMenuKey.currentState!;
      state.isOpened ? state.closeSideMenu() : state.openSideMenu();
    }

    return SideMenu(
      key: sideMenuKey,
      background: AppColors.black,
      type: SideMenuType.shrinkNSlide,
      menu: MenuAside(
        context,
        closeMenu: () => sideMenuKey.currentState?.closeSideMenu(),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              /// Fond terrain
              Positioned.fill(
                child: Image.asset(ImagePath.FIELD, fit: BoxFit.cover),
              ),

              /// Joueurs titulaires
              ...formationPositions[selectedFormation]!.asMap().entries.map((
                entry,
              ) {
                final index = entry.key;
                final pos = entry.value;
                return AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  left: MediaQuery.of(context).size.width * pos.dx - 30,
                  top: MediaQuery.of(context).size.height * pos.dy - 120,
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
                );
              }),

              /// Remplaçants
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 90,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: remplacants.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HexButton(
                          joueur: remplacants[index],
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
                        ),
                      );
                    },
                  ),
                ),
              ),

              /// AppBar/Menu
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => toggleMenu(),
                  ),
                ),
              ),

              /// Dropdown formation stylisé
              Positioned(
                top: kToolbarHeight + 8,
                right: 16,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: FormationDropdown(
                    formations: formations,
                    selectedFormation: selectedFormation,
                    onChanged: (value) {
                      setState(() => selectedFormation = value!);
                    },
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
