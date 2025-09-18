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
import 'package:inazuma_eleven_team_builder/widget/team_header.dart';
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
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

  // === Actions ===
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

  void resetTeam() {
    setState(() {
      hexPlayers = List.filled(11, null);
      remplacants = List.filled(5, null);
      selectedCoach = null;
      selectedMaillot = null;
      selectedEcusson = null;
    });
  }

  void movePlayer({
    required int fromIndex,
    required int toIndex,
    required bool fromIsRemplacant,
    required bool toIsRemplacant,
  }) {
    setState(() {
      if (fromIsRemplacant && toIsRemplacant) {
        final temp = remplacants[fromIndex];
        remplacants[fromIndex] = remplacants[toIndex];
        remplacants[toIndex] = temp;
      } else if (!fromIsRemplacant && !toIsRemplacant) {
        final temp = hexPlayers[fromIndex];
        hexPlayers[fromIndex] = hexPlayers[toIndex];
        hexPlayers[toIndex] = temp;
      } else if (!fromIsRemplacant && toIsRemplacant) {
        final temp = hexPlayers[fromIndex];
        hexPlayers[fromIndex] = remplacants[toIndex];
        remplacants[toIndex] = temp;
      } else if (fromIsRemplacant && !toIsRemplacant) {
        final temp = remplacants[fromIndex];
        remplacants[fromIndex] = hexPlayers[toIndex];
        hexPlayers[toIndex] = temp;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: CustomScrollView(
          slivers: [
            // === HEADER VICTORY ROAD ===
            TeamHeader(
              selectedFormation: selectedFormation,
              selectedCoach: selectedCoach,
              selectedMaillot: selectedMaillot,
              selectedEcusson: selectedEcusson,
              formations: formations,
              onFormationChanged: (f) => setState(() => selectedFormation = f),
              onOpenCoachSelector: openCoachSelector,
              onOpenMaillotSelector: openMaillotSelector,
              onOpenClubSelector: openClubSelector,
              onToggleMenu: toggleMenu,
              onResetTeam: resetTeam,
            ),

            // === TERRAIN + JOUEURS ===
            SliverFillRemaining(
              hasScrollBody: false,
              child: Stack(
                children: [
                  /// Fond terrain
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(ImagePath.FIELD, fit: BoxFit.cover),
                    ),
                  ),

                  /// Joueurs titulaires
                  ...formationPositions[selectedFormation]!.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final pos = entry.value;
                      return AnimatedPositioned(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOutBack,
                        left: MediaQuery.of(context).size.width * pos.dx - 30,
                        top: MediaQuery.of(context).size.height * pos.dy - 160,
                        child: AnimatedScale(
                          scale: hexPlayers[index] == null ? 0.9 : 1.0,
                          duration: const Duration(milliseconds: 300),
                          child: HexButton(
                            joueur: hexPlayers[index],
                            index: index,
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
                            onPlayerMoved:
                                (
                                  fromIndex,
                                  toIndex,
                                  fromIsRemplacant,
                                  toIsRemplacant,
                                ) {
                                  movePlayer(
                                    fromIndex: fromIndex,
                                    toIndex: toIndex,
                                    fromIsRemplacant: fromIsRemplacant,
                                    toIsRemplacant: toIsRemplacant,
                                  );
                                },
                          ),
                        ),
                      );
                    },
                  ),

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
                            index: index,
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
                            onPlayerMoved:
                                (
                                  fromIndex,
                                  toIndex,
                                  fromIsRemplacant,
                                  toIsRemplacant,
                                ) {
                                  movePlayer(
                                    fromIndex: fromIndex,
                                    toIndex: toIndex,
                                    fromIsRemplacant: fromIsRemplacant,
                                    toIsRemplacant: toIsRemplacant,
                                  );
                                },
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
