// lib/widget/player_detail_dialog.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import '../models/joueur.dart';
import 'poste_badge.dart';

class PlayerDetailDialog extends StatefulWidget {
  final Joueur joueur;

  const PlayerDetailDialog({super.key, required this.joueur});

  @override
  State<PlayerDetailDialog> createState() => _PlayerDetailDialogState();
}

class _PlayerDetailDialogState extends State<PlayerDetailDialog> {
  // 6 emplacements pour techniques (front only)
  final List<String?> techniques = List.generate(6, (_) => null);

  void _editTechnique(int slot) async {
    final TextEditingController c = TextEditingController(
      text: techniques[slot] ?? '',
    );
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Éditer la technique'),
          content: TextField(
            controller: c,
            decoration: const InputDecoration(hintText: 'Nom de la technique'),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () => Navigator.of(
                ctx,
              ).pop(c.text.trim().isEmpty ? null : c.text.trim()),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() => techniques[slot] = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final j = widget.joueur;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blueSky, Color(0xFF1FAF68)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 18),
          ],
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680, maxHeight: 640),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // header: icon + name + ecusson + poste
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          j.icon,
                          width: 88,
                          height: 88,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              j.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                PosteText(poste: j.poste),
                                const SizedBox(width: 10),
                                if (j.equipeEcusson != null)
                                  Image.asset(
                                    j.equipeEcusson!,
                                    width: 36,
                                    height: 36,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  'Poste: ${j.poste}',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // big area (desc placeholder)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Description / bio du joueur (placeholder). '
                      'Ici on affichera stats, types, etc. (plus tard).',
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Techniques list (6 slots)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Techniques',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: techniques.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final t = techniques[i];
                        return GestureDetector(
                          onTap: () => _editTechnique(i),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: t == null
                                  ? Colors.white
                                  : AppColors.blueSky.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black12),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  ' ${i + 1}.',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    t ?? 'Aucune technique assignée',
                                    style: TextStyle(
                                      color: t == null
                                          ? Colors.black38
                                          : Colors.black87,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.edit, color: Colors.black45),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 12),

                  // actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Fermer'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          // pour l'instant on ferme — plus tard on peut renvoyer les techniques
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueSky,
                        ),
                        child: const Text('Valider'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
