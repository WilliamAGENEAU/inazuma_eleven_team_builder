import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/joueur.dart';

class PlayerDetailPage extends StatelessWidget {
  final Joueur joueur;
  final String? equipeName;

  const PlayerDetailPage({super.key, required this.joueur, this.equipeName});

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF00A0FF), Color(0xFF00E676), Color(0xFFFFEE58)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFD),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 140,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: gradient,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -20,
                    child: Opacity(
                      opacity: .15,
                      child: Icon(
                        Icons.sports_soccer,
                        size: 200,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        joueur.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      if (equipeName != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            equipeName!,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Image + fiche
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Hero(
                    tag: 'joueur_${joueur.id}',
                    child: Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0F7FA)),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          (joueur.icon.isNotEmpty) ? joueur.icon : joueur.icon,
                          fit: BoxFit.contain,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Caractéristiques
                  _InfoTile(
                    title: 'Poste',
                    value: joueur.poste,
                    icon: Icons.shield,
                  ),
                  _InfoTile(
                    title: 'Type',
                    value: joueur.type,
                    icon: Icons.local_fire_department,
                  ),
                  _InfoTile(
                    title: 'Techniques',
                    value: (joueur.techniques.isNotEmpty)
                        ? joueur.techniques.join(' · ')
                        : '—',
                    icon: Icons.auto_awesome,
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

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0F7FA)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF00A0FF)),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
