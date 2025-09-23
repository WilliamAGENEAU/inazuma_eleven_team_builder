// lib/widget/player_detail_dialog.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/models/techniques.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'package:inazuma_eleven_team_builder/widget/video_player_widget.dart';
import '../models/joueur.dart';
import 'poste_badge.dart';
import '../services/local_storage_service.dart'; // NEW

class PlayerDetailDialog extends StatefulWidget {
  final Joueur joueur;

  const PlayerDetailDialog({super.key, required this.joueur});

  @override
  State<PlayerDetailDialog> createState() => _PlayerDetailDialogState();
}

class _PlayerDetailDialogState extends State<PlayerDetailDialog> {
  List<Technique?> techniquesSlots = List.generate(6, (_) => null);

  @override
  void initState() {
    super.initState();
    _loadTechniques();
  }

  Future<void> _loadTechniques() async {
    final saved = await LocalStorageService.loadTechniques(widget.joueur.id);
    setState(() => techniquesSlots = saved);
  }

  Future<void> _saveTechniques() async {
    await LocalStorageService.saveTechniques(widget.joueur.id, techniquesSlots);
  }

  void _selectTechnique(int slot, List<Technique> techniques) async {
    final selected = await showDialog<Technique>(
      context: context,
      builder: (ctx) => Dialog(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: techniques.length,
          itemBuilder: (_, i) {
            final tech = techniques[i];
            return GestureDetector(
              onTap: () => Navigator.of(ctx).pop(tech),
              child: Card(
                elevation: 3,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubeVideoPlayer(url: tech.url),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tech.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      tech.poste,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    if (selected != null) {
      setState(() {
        techniquesSlots[slot] = selected;
      });
      _saveTechniques(); // Sauvegarde automatique
    }
  }

  Widget _buildTechniqueSlot(int index, Joueur joueur) {
    final selected = techniquesSlots[index];
    Color bg;
    switch (selected?.poste) {
      case 'GK':
        bg = Colors.yellow.shade200;
        break;
      case 'DF':
        bg = Colors.green.shade200;
        break;
      case 'ATT':
        bg = Colors.blue.shade200;
        break;
      case 'TIR':
        bg = Colors.red.shade200;
        break;
      default:
        bg = Colors.grey.shade200;
    }

    return GestureDetector(
      onTap: () => _selectTechnique(index, joueur.techniques),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Text(
              ' ${index + 1}.',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                selected == null
                    ? 'Aucune technique assignée'
                    : '${selected.poste} - ${selected.name}',
                style: TextStyle(
                  color: selected == null ? Colors.black38 : Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.edit, color: Colors.black45),
          ],
        ),
      ),
    );
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
                  // HEADER joueur
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

                  // TECHNIQUES
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
                      itemCount: techniquesSlots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, i) => _buildTechniqueSlot(i, j),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
