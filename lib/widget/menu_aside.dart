// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';

Widget MenuAside(BuildContext context, {VoidCallback? closeMenu}) {
  return Column(
    children: [
      Expanded(
        flex: 1,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                onTap: () {
                  closeMenu?.call();
                  Navigator.popAndPushNamed(context, StringConst.HOME_PAGE);
                },
                leading: Icon(
                  FontAwesome5.teamspeak,
                  size: 20.0,
                  color: AppColors.white,
                ),
                title: const Text(
                  StringConst.MENU_HOME,
                  style: TextStyle(fontSize: 14),
                ),
                textColor: AppColors.white,
                dense: true,
              ),
              ListTile(
                onTap: () {
                  closeMenu?.call(); // ferme le menu si défini
                  Navigator.popAndPushNamed(context, StringConst.INFO_PAGE);
                },
                leading: Icon(
                  FontAwesome5.list,
                  size: 20.0,
                  color: AppColors.white,
                ),
                title: const Text(
                  StringConst
                      .MENU_INFO, // j’ai changé pour que ça ne soit pas "MENU_HOME"
                  style: TextStyle(fontSize: 14),
                ),
                textColor: AppColors.white,
                dense: true,
              ),
            ],
          ),
        ),
      ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(bottom: Pad.sm, left: Pad.sm),
        child: Text('v1.0.0', style: TextStyle(color: AppColors.white)),
      ),
    ],
  );
}
