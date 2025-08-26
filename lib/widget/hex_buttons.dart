import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/widget/hexagon_clipper.dart';

class HexButton extends StatelessWidget {
  final VoidCallback? onTap;

  const HexButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: ClipPath(
        clipper: HexagonClipper(),
        child: Container(
          width: 50,
          height: 50,
          color: Colors.grey,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
