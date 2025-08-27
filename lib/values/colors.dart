// values.dart (AppColors)
part of 'values.dart';

class AppColors {
  static const Color blueSky = Color(0xFF4FC3F7); // Bleu ciel
  static const Color greenEnergy = Color(0xFF81C784); // Vert lumineux
  static const Color yellowEnergy = Color(0xFFFFEB3B); // Jaune éclatant
  static const Color orangeFlash = Color(0xFFFF9800); // Orange flash
  static const Color deepBlue = Color(0xFF1565C0); // Bleu profond

  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color grey700 = Color(0xFF616161);
  static const Color grey300 = Color(0xFFE0E0E0);

  static const Color errorRed = Color(0xFFE53935);

  /// Gradients inspirés de Victory Road
  static const LinearGradient mainGradient = LinearGradient(
    colors: [blueSky, greenEnergy, yellowEnergy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [deepBlue, blueSky],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
