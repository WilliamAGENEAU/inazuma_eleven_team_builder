// lib/widget/player_detail_zone.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/player_details_dialog.dart';
import '../models/drag_player_data.dart';

class PlayerDetailZone extends StatefulWidget {
  final double width;
  final double height;

  const PlayerDetailZone({super.key, this.width = 260, this.height = 160});

  @override
  State<PlayerDetailZone> createState() => _PlayerDetailZoneState();
}

class _PlayerDetailZoneState extends State<PlayerDetailZone> {
  DragPlayerData? lastDropped;

  @override
  Widget build(BuildContext context) {
    return DragTarget<DragPlayerData>(
      onWillAccept: (data) {
        // highlight and accept all DragPlayerData
        return data != null;
      },
      onAccept: (data) async {
        setState(() => lastDropped = data);
        // ouvre le dialog "gros" avec toutes les infos + 6 slots de techniques
        await showDialog(
          context: context,
          builder: (_) => PlayerDetailDialog(joueur: data.joueur),
        );
        // tu peux faire quelque chose après la fermeture si tu veux
      },
      builder: (context, candidateData, rejected) {
        final hovering = candidateData.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.width,
          height: widget.height,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient: hovering
                ? LinearGradient(
                    colors: [AppColors.blueSky.withOpacity(0.25), Colors.white],
                  )
                : LinearGradient(colors: [Colors.white, Colors.white]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
            ],
            border: Border.all(
              color: hovering ? AppColors.blueSky : Colors.black12,
              width: hovering ? 2 : 1,
            ),
          ),
          child: lastDropped == null
              ? Center(
                  child: Icon(
                    Icons.electric_bolt,
                    color: Colors.black26,
                    size: 48,
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    lastDropped!.joueur.icon,
                    fit: BoxFit.cover,
                  ),
                ),
        );
      },
    );
  }
}
