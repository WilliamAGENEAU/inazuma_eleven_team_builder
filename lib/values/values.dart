// ignore: unnecessary_library_name
library values;

import 'package:flutter/material.dart';

part 'colors.dart';
// part 'borders.dart';
part 'images.dart';
part 'sizes.dart';
part 'strings.dart';

// part 'styles.dart';
// part 'gradients.dart';
// part 'decoration.dart';
// part 'data.dart';
// part 'docs.dart';
// part 'animations.dart';
final Map<String, List<Offset>> formationPositions = {
  "4-3-3": [
    Offset(0.5, 0.77), // Gardien
    Offset(0.1, 0.65), Offset(0.35, 0.65),
    Offset(0.6, 0.65), Offset(0.85, 0.65), // Défense
    Offset(0.2, 0.5), Offset(0.5, 0.5), Offset(0.8, 0.5), // Milieu
    Offset(0.2, 0.35), Offset(0.5, 0.30), Offset(0.8, 0.35), // Attaque
  ],
  "4-2-3-1": [
    Offset(0.5, 0.77), // Gardien
    Offset(0.1, 0.65), Offset(0.35, 0.65),
    Offset(0.6, 0.65), Offset(0.85, 0.65), // Défense
    Offset(0.35, 0.5), Offset(0.65, 0.5),
    Offset(0.2, 0.4), Offset(0.5, 0.4), Offset(0.8, 0.4),
    Offset(0.5, 0.3), // Attaque
  ],
  "4-4-2": [
    Offset(0.5, 0.77),
    Offset(0.1, 0.65), Offset(0.35, 0.65),
    Offset(0.6, 0.65), Offset(0.85, 0.65), // Défense
    Offset(0.1, 0.5),
    Offset(0.35, 0.5),
    Offset(0.6, 0.5),
    Offset(0.85, 0.5),
    Offset(0.35, 0.35),
    Offset(0.65, 0.35),
  ],
  "3-5-2": [
    Offset(0.5, 0.77),
    Offset(0.2, 0.65),
    Offset(0.5, 0.65),
    Offset(0.8, 0.65),
    Offset(0.1, 0.5),
    Offset(0.35, 0.5),
    Offset(0.6, 0.5),
    Offset(0.85, 0.5),
    Offset(0.48, 0.4),
    Offset(0.3, 0.3),
    Offset(0.7, 0.3),
  ],
  "3-4-3": [
    Offset(0.5, 0.77),
    Offset(0.2, 0.65),
    Offset(0.5, 0.65),
    Offset(0.8, 0.65),
    Offset(0.1, 0.5),
    Offset(0.35, 0.5),
    Offset(0.6, 0.5),
    Offset(0.85, 0.5),
    Offset(0.2, 0.35), Offset(0.5, 0.30), Offset(0.8, 0.35), // Attaque
  ],
};
