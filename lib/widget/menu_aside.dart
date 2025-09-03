// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';

Widget MenuAside(BuildContext context, {VoidCallback? closeMenu}) {
  final gradient = const LinearGradient(
    colors: [Colors.blue, Colors.greenAccent, Colors.yellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  return Column(
    children: [
      // 🔹 Header avec gradient Victory Road
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Icon(Icons.sports_soccer, color: Colors.white, size: 40),
            SizedBox(height: 12),
            Text(
              "Inazuma Eleven",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Team Builder",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),

      // 🔹 Items du menu
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              _buildMenuItem(
                context,
                icon: FontAwesome5.teamspeak,
                label: StringConst.MENU_HOME,
                route: StringConst.HOME_PAGE,
                closeMenu: closeMenu,
              ),
              _buildMenuItem(
                context,
                icon: Icons.menu_book,
                label: StringConst.MENU_INFO,
                route: StringConst.INFO_PAGE,
                closeMenu: closeMenu,
              ),
            ],
          ),
        ),
      ),

      // 🔹 Footer avec version
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 16, bottom: 12),
        child: const Text(
          "v1.0.0",
          style: TextStyle(color: Colors.black, fontSize: 12),
        ),
      ),
    ],
  );
}

/// 🔹 Item du menu avec animation au clic
Widget _buildMenuItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String route,
  VoidCallback? closeMenu,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        closeMenu?.call();
        Navigator.popAndPushNamed(context, route);
      },
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(icon, size: 22, color: Colors.black),
          title: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.black),
        ),
      ),
    ),
  );
}
