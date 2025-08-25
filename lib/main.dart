import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/routes/routes.dart';
import 'package:inazuma_eleven_team_builder/sections/home/home_page.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'app_theme.dart';
import 'package:layout/layout.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        title: StringConst.APP_TITLE,
        theme: AppTheme.lightThemeData,
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.homePageRoute,
        onGenerateRoute: RouteConfiguration.onGenerateRoute,
      ),
    );
  }
}
