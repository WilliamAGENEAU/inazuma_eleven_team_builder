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
    Offset(0.5, 0.875), // Gardien
    Offset(0.2, 0.75), Offset(0.4, 0.75),
    Offset(0.6, 0.75), Offset(0.8, 0.75), // Défense
    Offset(0.2, 0.6), Offset(0.5, 0.6), Offset(0.8, 0.6), // Milieu
    Offset(0.2, 0.45), Offset(0.5, 0.4), Offset(0.8, 0.45), // Attaque
  ],
  "4-4-2": [
    Offset(0.5, 0.875),
    Offset(0.2, 0.75),
    Offset(0.4, 0.75),
    Offset(0.6, 0.75),
    Offset(0.8, 0.75),
    Offset(0.2, 0.6),
    Offset(0.4, 0.6),
    Offset(0.6, 0.6),
    Offset(0.8, 0.6),
    Offset(0.4, 0.45),
    Offset(0.6, 0.45),
  ],
  "3-5-2": [
    Offset(0.5, 0.875),
    Offset(0.3, 0.75),
    Offset(0.5, 0.75),
    Offset(0.7, 0.75),
    Offset(0.15, 0.6),
    Offset(0.4, 0.6),
    Offset(0.6, 0.6),
    Offset(0.85, 0.6),
    Offset(0.5, 0.5),
    Offset(0.4, 0.4),
    Offset(0.6, 0.4),
  ],
  "5-3-2": [
    Offset(0.5, 0.875),
    Offset(0.15, 0.7),
    Offset(0.3, 0.75),
    Offset(0.5, 0.75),
    Offset(0.7, 0.75),
    Offset(0.85, 0.7),
    Offset(0.2, 0.6),
    Offset(0.5, 0.6),
    Offset(0.8, 0.6),
    Offset(0.4, 0.45),
    Offset(0.6, 0.45),
  ],
};
