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
    final double size = isRemplacant ? 65 : 75;

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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
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
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (joueur!.equipeEcusson != null &&
                    joueur!.equipeEcusson!.isNotEmpty) ...[
                  Image.asset(
                    joueur!.equipeEcusson!,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 4),
                ],
                Flexible(
                  child: Text(
                    joueur!.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
