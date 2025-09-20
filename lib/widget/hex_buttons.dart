// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/hexagon_clipper.dart';
import 'package:inazuma_eleven_team_builder/widget/poste_badge.dart';
import '../models/joueur.dart';

class HexButton extends StatelessWidget {
  final Joueur? joueur;
  final VoidCallback? onTap;
  final bool isRemplacant;
  final int index;
  final Function(
    int fromIndex,
    int toIndex,
    bool fromIsRemplacant,
    bool toIsRemplacant,
  )?
  onPlayerMoved;

  const HexButton({
    super.key,
    this.joueur,
    this.onTap,
    this.isRemplacant = false,
    required this.index,
    this.onPlayerMoved,
  });
  String getFirstName(String fullName) {
    return fullName.split(" ").first;
  }

  @override
  Widget build(BuildContext context) {
    final double size = isRemplacant ? 65 : 75;

    final hexContent = ClipPath(
      clipper: HexagonClipper(),
      child: Container(
        width: size, // toujours la même largeur
        height: size, // toujours la même hauteur
        alignment: Alignment.center, // centre l’enfant
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blueSky, Color(0xFF1FAF68)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: joueur == null
            ? const Icon(Icons.add, color: Colors.white, size: 22)
            : Image.asset(
                joueur!.icon,
                fit: BoxFit.cover,
                width: size, // on force à rester dans la boîte
                height: size,
              ),
      ),
    );

    return DragTarget<Map<String, dynamic>>(
      onAccept: (data) {
        if (onPlayerMoved != null) {
          onPlayerMoved!(
            data["index"],
            index,
            data["isRemplacant"],
            isRemplacant,
          );
        }
      },
      builder: (context, candidateData, rejectedData) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: joueur == null
                  ? hexContent
                  : Draggable<Map<String, dynamic>>(
                      data: {
                        "joueur": joueur,
                        "index": index,
                        "isRemplacant": isRemplacant,
                      },
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: hexContent,
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: hexContent,
                      ),
                      child: hexContent,
                    ),
            ),
            if (joueur != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PosteText(poste: joueur!.poste),
                  const SizedBox(width: 6),
                  Text(
                    getFirstName(joueur!.name),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 6),
                  if (joueur!.equipeEcusson != null)
                    Image.asset(joueur!.equipeEcusson!, height: 20),
                ],
              ),
          ],
        );
        return content;
      },
    );
  }
}
