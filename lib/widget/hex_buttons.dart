import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/hexagon_clipper.dart';
import '../models/joueur.dart';

class HexButton extends StatelessWidget {
  final Joueur? joueur;
  final VoidCallback? onTap;
  final bool isRemplacant;

  const HexButton({
    super.key,
    this.joueur,
    this.onTap,
    this.isRemplacant = false,
  });

  @override
  Widget build(BuildContext context) {
    final double size = isRemplacant ? 65 : 75; // 👈 taille réduite remplaçants

    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipPath(
            clipper: HexagonClipper(),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.blueSky, Color(0xFF1FAF68)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: joueur == null
                  ? const Icon(Icons.add, color: Colors.white, size: 22)
                  : Image.asset(joueur!.icon, fit: BoxFit.cover),
            ),
          ),
          if (joueur != null) ...[
            Text(
              joueur!.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
