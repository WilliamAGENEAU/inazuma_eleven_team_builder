// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/joueur.dart';
import 'package:inazuma_eleven_team_builder/services/local_storage_service.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/club_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/coach_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/hex_buttons.dart';
import 'package:inazuma_eleven_team_builder/widget/maillot_selector_bottom_sheet.dart';
import 'package:inazuma_eleven_team_builder/widget/menu_aside.dart';
import 'package:inazuma_eleven_team_builder/widget/player_detail_zone.dart';
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

  final List<String> formations = [
    "4-3-3",
    "4-4-2",
    "3-5-2",
    "3-4-3",
    "4-2-3-1",
  ];
  final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();

  @override
  void initState() {
    super.initState();
    _restoreState();
  }

  Future<void> _restoreState() async {
    final savedPlayers = await LocalStorageService.loadPlayers();
    final savedCoach = await LocalStorageService.loadCoach();
    final savedMaillot = await LocalStorageService.loadMaillot();
    final savedEcusson = await LocalStorageService.loadEcusson();
    final savedFormation = await LocalStorageService.loadFormation();

    setState(() {
      if (savedPlayers.containsKey("terrain")) {
        hexPlayers = List.generate(11, (i) {
          final data = savedPlayers["terrain"]["$i"];
          return data != null
              ? Joueur.fromFirestore(data, data["id"], [])
              : null;
        });
      }
      if (savedPlayers.containsKey("remplacants")) {
        remplacants = List.generate(5, (i) {
          final data = savedPlayers["remplacants"]["$i"];
          return data != null
              ? Joueur.fromFirestore(data, data["id"], [])
              : null;
        });
      }

      selectedCoach = savedCoach;
      selectedMaillot = savedMaillot;
      selectedEcusson = savedEcusson;
      if (savedFormation != null) selectedFormation = savedFormation;
    });
  }

  // === Actions ===
  void openCoachSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CoachSelectorBottomSheet(
        onCoachSelected: (coach) async {
          await LocalStorageService.saveCoach(coach);
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
        onMaillotSelected: (maillot) async {
          await LocalStorageService.saveMaillot(maillot);
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
        onEcussonSelected: (club) async {
          await LocalStorageService.saveEcusson(club);
          setState(() => selectedEcusson = club);
        },
      ),
    );
  }

  void toggleMenu() {
    final state = sideMenuKey.currentState!;
    state.isOpened ? state.closeSideMenu() : state.openSideMenu();
  }

  void resetTeam() async {
    await LocalStorageService.resetAll();
    setState(() {
      hexPlayers = List.filled(11, null);
      remplacants = List.filled(5, null);
      selectedCoach = null;
      selectedMaillot = null;
      selectedEcusson = null;
    });
  }

  Future<void> _savePlayers() async {
    final playersData = {
      "terrain": {
        for (int i = 0; i < hexPlayers.length; i++)
          "$i": hexPlayers[i] != null
              ? {
                  "id": hexPlayers[i]!.id,
                  "name": hexPlayers[i]!.name,
                  "poste": hexPlayers[i]!.poste,
                  "icon": hexPlayers[i]!.icon,
                  "type": hexPlayers[i]!.type,
                  "ecusson": hexPlayers[i]!.equipeEcusson,
                }
              : null,
      },
      "remplacants": {
        for (int i = 0; i < remplacants.length; i++)
          "$i": remplacants[i] != null
              ? {
                  "id": remplacants[i]!.id,
                  "name": remplacants[i]!.name,
                  "poste": remplacants[i]!.poste,
                  "icon": remplacants[i]!.icon,
                  "type": remplacants[i]!.type,
                  "ecusson": remplacants[i]!.equipeEcusson,
                }
              : null,
      },
    };
    await LocalStorageService.savePlayers(playersData);
  }

  void movePlayer(
    int fromIndex,
    int toIndex,
    bool fromIsRemplacant,
    bool toIsRemplacant,
  ) {
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
            // === HEADER ===
            TeamHeader(
              selectedFormation: selectedFormation,
              selectedCoach: selectedCoach,
              selectedMaillot: selectedMaillot,
              selectedEcusson: selectedEcusson,
              formations: formations,
              onFormationChanged: (f) async {
                await LocalStorageService.saveFormation(f);
                setState(() => selectedFormation = f);
              },
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
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(ImagePath.FIELD, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: PlayerDetailZone(width: 100, height: 100),
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
                                  onPlayerSelected: (joueur) async {
                                    setState(() => hexPlayers[index] = joueur);
                                    await _savePlayers();
                                  },
                                ),
                              );
                            },
                            onPlayerMoved: movePlayer,
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
                                  onPlayerSelected: (joueur) async {
                                    setState(() => remplacants[index] = joueur);
                                    await _savePlayers();
                                  },
                                ),
                              );
                            },
                            onPlayerMoved: movePlayer,
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
