import 'joueur.dart';

class DragPlayerData {
  final Joueur joueur;
  final int index;
  final bool isRemplacant;

  DragPlayerData({
    required this.joueur,
    required this.index,
    required this.isRemplacant,
  });
}
