// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/hexagon_clipper.dart';
import 'package:inazuma_eleven_team_builder/widget/poste_badge.dart';
import '../models/joueur.dart';
import '../models/drag_player_data.dart';

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
    final double size = isRemplacant ? 60 : 72;

    Widget buildHex(Joueur? j, {bool greyed = false}) {
      return ClipPath(
        clipper: HexagonClipper(),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.blueSky, Color(0xFF1FAF68)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: j == null
              ? const Icon(Icons.add, color: Colors.white, size: 22)
              : ColorFiltered(
                  colorFilter: greyed
                      ? const ColorFilter.mode(
                          Colors.grey,
                          BlendMode.saturation,
                        )
                      : const ColorFilter.mode(
                          Colors.transparent,
                          BlendMode.multiply,
                        ),
                  child: Image.asset(
                    j.icon,
                    fit: BoxFit.cover,
                    width: size,
                    height: size,
                  ),
                ),
        ),
      );
    }

    return DragTarget<DragPlayerData>(
      onWillAccept: (data) {
        // debug
        if (data != null) {
          // accepte toujours (tu peux filtrer si tu veux)
          debugPrint(
            'HexButton #$index onWillAccept from ${data.index} (remp:${data.isRemplacant})',
          );
          return true;
        }
        return false;
      },
      onAccept: (data) {
        debugPrint('HexButton #$index onAccept from ${data.index}');
        if (onPlayerMoved != null) {
          onPlayerMoved!(data.index, index, data.isRemplacant, isRemplacant);
        }
      },
      builder: (context, candidateData, rejectedData) {
        final hex = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onTap,
              child: joueur == null
                  ? buildHex(null)
                  : Draggable<DragPlayerData>(
                      data: DragPlayerData(
                        joueur: joueur!,
                        index: index,
                        isRemplacant: isRemplacant,
                      ),
                      feedback: Material(
                        color: Colors.transparent,
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: buildHex(joueur),
                        ),
                      ),
                      childWhenDragging: buildHex(joueur, greyed: true),
                      child: buildHex(joueur),
                    ),
            ),
            if (joueur != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PosteText(
                      poste: joueur!.poste,
                    ), // badge de poste (couleur + 2 lettres)
                    const SizedBox(width: 6),
                    Text(
                      getFirstName(joueur!.name),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 6),
                    if (joueur!.equipeEcusson != null)
                      Image.asset(joueur!.equipeEcusson!, height: 18),
                  ],
                ),
              ),
          ],
        );

        // si on veut indiquer visuellement la zone d'accueil pendant hover :
        final bool hovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          transform: hovering ? Matrix4.identity() : Matrix4.identity(),
          child: hex,
        );
      },
    );
  }
}
