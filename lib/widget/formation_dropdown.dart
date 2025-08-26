import 'package:flutter/material.dart';

class FormationDropdown extends StatelessWidget {
  final List<String> formations;
  final String selectedFormation;
  final ValueChanged<String?> onChanged;

  const FormationDropdown({
    super.key,
    required this.formations,
    required this.selectedFormation,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160, // 👈 largeur fixe pour éviter l'erreur
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 important !
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Formation",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true, // 👈 prend toute la largeur
              value: selectedFormation,
              dropdownColor: Colors.grey[900],
              style: const TextStyle(color: Colors.white, fontSize: 16),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              items: formations.map((f) {
                return DropdownMenuItem(value: f, child: Text(f));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
