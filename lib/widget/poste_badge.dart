import 'package:flutter/material.dart';

class PosteText extends StatelessWidget {
  final String poste;

  const PosteText({super.key, required this.poste});

  Color _getColor() {
    switch (poste) {
      case 'GK':
        return Colors.grey;
      case 'DF':
        return Colors.blue;
      case 'MF':
        return Colors.orange;
      case 'FW':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      poste,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: _getColor(),
        shadows: const [
          Shadow(color: Colors.black, offset: Offset(0.5, 0.5), blurRadius: 1),
        ],
      ),
    );
  }
}
