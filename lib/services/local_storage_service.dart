// lib/services/local_storage_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/techniques.dart';

class LocalStorageService {
  static const String playersKey = "players";
  static const String coachKey = "coach";
  static const String maillotKey = "maillot";
  static const String ecussonKey = "ecusson";
  static const String formationKey = "formation";
  static const String techniquesKey = "techniques"; // NEW

  // --- FORMATION ---
  static Future<void> saveFormation(String formation) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(formationKey, formation);
  }

  static Future<String?> loadFormation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(formationKey);
  }

  // --- PLAYERS ---
  static Future<void> savePlayers(Map<String, dynamic> playersData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(playersKey, jsonEncode(playersData));
  }

  static Future<Map<String, dynamic>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(playersKey);
    return json != null ? jsonDecode(json) : {};
  }

  // --- COACH ---
  static Future<void> saveCoach(String coach) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(coachKey, coach);
  }

  static Future<String?> loadCoach() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(coachKey);
  }

  // --- MAILLOT ---
  static Future<void> saveMaillot(String maillot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(maillotKey, maillot);
  }

  static Future<String?> loadMaillot() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(maillotKey);
  }

  // --- ECUSSON ---
  static Future<void> saveEcusson(String ecusson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ecussonKey, ecusson);
  }

  static Future<String?> loadEcusson() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(ecussonKey);
  }

  // --- TECHNIQUES PAR JOUEUR ---
  static Future<void> saveTechniques(
    String joueurId,
    List<Technique?> slots,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final data = slots
        .map(
          (t) => t == null
              ? null
              : {"name": t.name, "poste": t.poste, "url": t.url},
        )
        .toList();
    await prefs.setString("$techniquesKey-$joueurId", jsonEncode(data));
  }

  static Future<List<Technique?>> loadTechniques(String joueurId) async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString("$techniquesKey-$joueurId");
    if (json == null) return List.generate(6, (_) => null);

    final List<dynamic> data = jsonDecode(json);
    return data.map((item) {
      if (item == null) return null;
      return Technique(
        id: item["name"],
        name: item["name"],
        poste: item["poste"],
        url: item["url"],
      );
    }).toList();
  }

  // --- RESET ---
  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
