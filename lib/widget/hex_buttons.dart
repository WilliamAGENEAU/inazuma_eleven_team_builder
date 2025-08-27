import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/widget/hexagon_clipper.dart';
import '../models/joueur.dart';

class HexButton extends StatelessWidget {
  final Joueur? joueur;
  final VoidCallback? onTap;

  const HexButton({super.key, this.joueur, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: ClipPath(
        clipper: HexagonClipper(),
        child: Container(
          width: 60,
          height: 60,
          color: Colors.grey[800],
          child: joueur == null
              ? const Icon(Icons.add, color: Colors.white)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(joueur!.icon, fit: BoxFit.cover),
                ),
        ),
      ),
    );
  }
}
