import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/formation_dropdown.dart';
import 'package:inazuma_eleven_team_builder/widget/hex_buttons.dart';
import 'package:inazuma_eleven_team_builder/widget/menu_aside.dart';
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

  final List<String> formations = ["4-3-3", "4-4-2", "3-5-2", "5-3-2"];

  /// Positions de joueurs sur le terrain (normalisées entre 0 et 1)
  final Map<String, List<Offset>> formationPositions = {
    "4-3-3": [
      Offset(0.5, 0.9), // Gardien
      Offset(0.2, 0.8),
      Offset(0.4, 0.8),
      Offset(0.6, 0.8),
      Offset(0.8, 0.8), // Défense
      Offset(0.2, 0.6), Offset(0.5, 0.6), Offset(0.8, 0.6), // Milieu
      Offset(0.2, 0.4),
      Offset(0.5, 0.4),
      Offset(0.8, 0.4), // Attaque 👈 pointe descendue
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
      if (state.isOpened) {
        state.closeSideMenu();
      } else {
        state.openSideMenu();
      }
    }

    return SideMenu(
      key: sideMenuKey,
      background: AppColors.black,
      type: SideMenuType.shrinkNSlide,
      menu: MenuAside(
        context,
        closeMenu: () => sideMenuKey.currentState?.closeSideMenu(),
      ),
      child: IgnorePointer(
        ignoring: isOpened,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                /// Fond du terrain
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 120,
                    ), // 👈 laisse la place pour le gardien + remplaçants
                    child: Image.asset(
                      ImagePath.FIELD,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),

                /// Boutons joueurs (avec ajustement des positions)
                ...formationPositions[selectedFormation]!.map(
                  (pos) => Positioned(
                    left: MediaQuery.of(context).size.width * pos.dx - 35,
                    top:
                        MediaQuery.of(context).size.height * (pos.dy * 0.85) -
                        35, // 👈 descend un peu les joueurs
                    child: SizedBox(width: 70, height: 70, child: HexButton()),
                  ),
                ),

                /// Zone des remplaçants
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 120,
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly, // 👈 espace égal entre remplaçants
                      children: List.generate(5, (index) {
                        return SizedBox(
                          width: 70,
                          height: 70,
                          child: HexButton(),
                        );
                      }),
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
                      icon: Icon(Icons.menu, color: AppColors.white),
                      onPressed: () => toggleMenu(),
                    ),
                  ),
                ),

                /// Dropdown sous l’AppBar, aligné à droite
                Positioned(
                  top: kToolbarHeight, // 👈 juste sous l’AppBar
                  right: 12,
                  child: FormationDropdown(
                    formations: formations,
                    selectedFormation: selectedFormation,
                    onChanged: (value) {
                      setState(() {
                        selectedFormation = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
