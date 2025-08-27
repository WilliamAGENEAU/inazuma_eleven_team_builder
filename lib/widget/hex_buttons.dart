import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: 70,
        height: 70,
        child: ClipPath(
          clipper: HexagonClipper(),
          child: Container(
            color: AppColors.grey300,
            child: joueur == null
                ? const Icon(Icons.add, color: Colors.white, size: 28)
                : Image.asset(joueur!.icon, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
