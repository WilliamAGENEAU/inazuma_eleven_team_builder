import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inazuma_eleven_team_builder/routes/routes.dart';
import 'package:inazuma_eleven_team_builder/sections/home/home_page.dart';
import 'package:inazuma_eleven_team_builder/values/values.dart';
import 'app_theme.dart';
import 'package:layout/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCTcIV9vTRwVZMzKnt1ATtaGpmHHXKMrfY",
      appId: "1:28930603241:android:ae05a3f4debb7238809878",
      messagingSenderId: "28930603241",
      projectId: "inazuma-eleven-team-builder",
      storageBucket: "inazuma-eleven-team-builder.firebasestorage.app",
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: MaterialApp(
        title: StringConst.APP_TITLE,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.homePageRoute,
        onGenerateRoute: RouteConfiguration.onGenerateRoute,
      ),
    );
  }
}
