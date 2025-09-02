// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/equipe.dart';
import 'package:inazuma_eleven_team_builder/models/joueur.dart';
import 'package:inazuma_eleven_team_builder/sections/info/player_detail.dart';
import 'package:inazuma_eleven_team_builder/services/firebase_service.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/menu_aside.dart';
import 'package:shrink_sidemenu/shrink_sidemenu.dart';

class PlayerEncyclopediaPage extends StatefulWidget {
  static const String infoPageRoute = StringConst.INFO_PAGE;

  final String? initialEquipeId; // équipe par défaut (optionnel)
  final String? initialEquipeName;

  const PlayerEncyclopediaPage({
    super.key,
    this.initialEquipeId,
    this.initialEquipeName,
  });

  @override
  State<PlayerEncyclopediaPage> createState() => _PlayerEncyclopediaPageState();
}

class _PlayerEncyclopediaPageState extends State<PlayerEncyclopediaPage> {
  final FirebaseService _db = FirebaseService();

  List<Equipe> _equipes = [];
  List<Joueur> _allPlayers = [];
  List<Joueur> _visiblePlayers = [];

  String? _selectedEquipeId;
  String? _selectedEquipeName;

  String? _selectedPoste; // Gardien / Défenseur / Milieu / Attaquant
  String? _selectedType; // Feu / Air / Bois / Terre

  bool _loading = true;

  final List<String> _postes = const [
    'Gardien',
    'Défenseur',
    'Milieu',
    'Attaquant',
  ];
  final List<String> _types = const ['Feu', 'Air', 'Bois', 'Terre'];

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() => _loading = true);

    // Récupère toutes les équipes (toutes sagas confondues) pour le filtre par équipe
    // -> Si tu veux limiter à une saga, ajoute un sélecteur de saga ici et appelle getEquipes(sagaId)
    final equipes = await _db.getAllEquipes();

    // Choix de l’équipe par défaut
    String? equipeId =
        widget.initialEquipeId ??
        (equipes.isNotEmpty ? equipes.first.id : null);
    String? equipeName =
        widget.initialEquipeName ??
        (equipes.isNotEmpty ? equipes.first.name : null);

    List<Joueur> joueurs = [];
    if (equipeId != null) {
      // On essaie de trouver la saga par l’équipe (service helper)
      final sagaId = await _db.getSagaIdByEquipeId(equipeId);
      if (sagaId != null) {
        joueurs = await _db.getJoueurs(sagaId, equipeId);
      }
    }

    setState(() {
      _equipes = equipes;
      _selectedEquipeId = equipeId;
      _selectedEquipeName = equipeName;
      _allPlayers = joueurs;
      _applyFilters();
      _loading = false;
    });
  }

  Future<void> _onEquipeChanged(Equipe eq) async {
    setState(() {
      _loading = true;
      _selectedEquipeId = eq.id;
      _selectedEquipeName = eq.name;
      _allPlayers = [];
      _visiblePlayers = [];
    });

    final sagaId = await _db.getSagaIdByEquipeId(eq.id);
    if (sagaId == null) {
      setState(() => _loading = false);
      return;
    }

    final joueurs = await _db.getJoueurs(sagaId, eq.id);
    setState(() {
      _allPlayers = joueurs;
      _applyFilters();
      _loading = false;
    });
  }

  void _applyFilters() {
    List<Joueur> list = List.of(_allPlayers);
    if (_selectedPoste != null) {
      list = list
          .where(
            (j) => (j.poste).toLowerCase() == _selectedPoste!.toLowerCase(),
          )
          .toList();
    }
    if (_selectedType != null) {
      list = list
          .where((j) => (j.type).toLowerCase() == _selectedType!.toLowerCase())
          .toList();
    }
    _visiblePlayers = list;
  }

  void _togglePoste(String poste) {
    setState(() {
      _selectedPoste = _selectedPoste == poste ? null : poste;
      _applyFilters();
    });
  }

  void _toggleType(String type) {
    setState(() {
      _selectedType = _selectedType == type ? null : type;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<SideMenuState> sideMenuKey = GlobalKey<SideMenuState>();
    void toggleMenu() {
      final state = sideMenuKey.currentState!;
      state.isOpened ? state.closeSideMenu() : state.openSideMenu();
    }

    final gradient = const LinearGradient(
      colors: [Color(0xFF00A0FF), Color(0xFF00E676), Color(0xFFFFEE58)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return SideMenu(
      key: sideMenuKey,
      background: AppColors.black,
      type: SideMenuType.shrinkNSlide,
      menu: MenuAside(
        context,
        closeMenu: () => sideMenuKey.currentState?.closeSideMenu(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // 🔹 Header façon Victory Road
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(gradient: gradient),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: toggleMenu,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          "Inazuma Dex",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Sélectionne une équipe",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(width: 48), // équilibre le Row
                  ],
                ),
              ),

              // Filtres
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: _EquipeDropdown(
                  equipes: _equipes,
                  selectedEquipeId: _selectedEquipeId,
                  onChanged: (eq) {
                    if (eq != null) _onEquipeChanged(eq);
                  },
                ),
              ),

              // Chips: Postes & Types
              _FilterChipsRow(
                title: 'Poste',
                values: _postes,
                selected: _selectedPoste,
                onTap: _togglePoste,
              ),
              _FilterChipsRow(
                title: 'Type',
                values: _types,
                selected: _selectedType,
                onTap: _toggleType,
              ),

              const SizedBox(height: 8),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _visiblePlayers.isEmpty
                      ? const Center(
                          child: Text(
                            'Aucun joueur',
                            style: TextStyle(color: Colors.black54),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: GridView.builder(
                            key: ValueKey(
                              '${_selectedEquipeId}_${_selectedPoste}_$_selectedType',
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: .78,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                ),
                            itemCount: _visiblePlayers.length,
                            itemBuilder: (ctx, i) {
                              final j = _visiblePlayers[i];
                              return _PlayerCard(
                                joueur: j,
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 400,
                                      ),
                                      pageBuilder: (_, __, ___) =>
                                          PlayerDetailPage(
                                            joueur: j,
                                            equipeName: _selectedEquipeName,
                                          ),
                                      transitionsBuilder:
                                          (_, anim, __, child) =>
                                              FadeTransition(
                                                opacity: anim,
                                                child: child,
                                              ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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

/// —————————————————————————————————————————————
/// UI — Dropdown équipe (par défaut)
class _EquipeDropdown extends StatelessWidget {
  final List<Equipe> equipes;
  final String? selectedEquipeId;
  final ValueChanged<Equipe?> onChanged;

  const _EquipeDropdown({
    required this.equipes,
    required this.selectedEquipeId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0F7FA)),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Équipe',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedEquipeId,
              icon: const Icon(Icons.expand_more),
              items: equipes.map((e) {
                return DropdownMenuItem<String>(
                  value: e.id,
                  child: Row(
                    children: [
                      if (e.image.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Image.asset(e.image, width: 24, height: 24),
                        ),
                      Text(
                        e.name,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (id) {
                final eq = equipes.firstWhere(
                  (x) => x.id == id,
                  orElse: () => equipes.first,
                );
                onChanged(eq);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// —————————————————————————————————————————————
/// UI — Chips filtres
class _FilterChipsRow extends StatelessWidget {
  final String title;
  final List<String> values;
  final String? selected;
  final ValueChanged<String> onTap;

  const _FilterChipsRow({
    required this.title,
    required this.values,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 12),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: values.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (ctx, i) {
                final v = values[i];
                final active = v == selected;
                return GestureDetector(
                  onTap: () => onTap(v),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: active
                          ? const LinearGradient(
                              colors: [Color(0xFF00A0FF), Color(0xFF00E676)],
                            )
                          : null,
                      color: active ? null : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: active
                            ? Colors.transparent
                            : const Color(0xFFE0F7FA),
                      ),
                      boxShadow: [
                        if (active)
                          const BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                      ],
                    ),
                    child: Text(
                      v,
                      style: TextStyle(
                        color: active ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// —————————————————————————————————————————————
/// UI — Card joueur (grille type Pokédex)
class _PlayerCard extends StatelessWidget {
  final Joueur joueur;
  final VoidCallback onTap;

  const _PlayerCard({required this.joueur, required this.onTap});

  Color _badgeColorForType(String? t) {
    switch ((t ?? '').toLowerCase()) {
      case 'feu':
        return const Color(0xFFFF7043);
      case 'air':
        return const Color(0xFF64B5F6);
      case 'bois':
        return const Color(0xFF81C784);
      case 'terre':
        return const Color(0xFFA1887F);
      default:
        return const Color(0xFFBDBDBD);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _badgeColorForType(joueur.type);

    return Hero(
      tag: 'joueur_${joueur.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE0F7FA)),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Bandeau gradient en haut
                Container(
                  height: 52,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    gradient: LinearGradient(
                      colors: [Color(0xFF00A0FF), Color(0xFF00E676)],
                    ),
                  ),
                ),
                // Image
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 32),
                    child: Image.asset(
                      joueur.icon,
                      fit: BoxFit.contain,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                // Nom + badge type en bas
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          joueur.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: typeColor.withOpacity(.6)),
                        ),
                        child: Text(
                          (joueur.type).isEmpty ? '—' : joueur.type,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: typeColor.darken(),
                            fontSize: 11,
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
      ),
    );
  }
}

// Petit helper pour foncer une couleur
extension on Color {
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
