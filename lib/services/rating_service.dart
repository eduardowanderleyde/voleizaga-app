import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rating.dart';

class RatingService {
  static const String _ratingsKey = 'player_ratings';

  static Future<List<Rating>> loadRatings() async {
    final prefs = await SharedPreferences.getInstance();
    final ratingsJson = prefs.getStringList(_ratingsKey) ?? [];

    return ratingsJson
        .map((json) => Rating.fromJson(jsonDecode(json)))
        .toList();
  }

  static Future<void> saveRating(Rating rating) async {
    final prefs = await SharedPreferences.getInstance();
    final ratings = await loadRatings();

    ratings.add(rating);

    final ratingsJson = ratings.map((r) => jsonEncode(r.toJson())).toList();

    await prefs.setStringList(_ratingsKey, ratingsJson);
  }

  static Future<List<Rating>> getPlayerRatings(String playerId) async {
    final ratings = await loadRatings();
    return ratings.where((r) => r.playerId == playerId).toList();
  }

  static Future<Map<String, double>> getPlayerAverageRatings(
      String playerId) async {
    final ratings = await getPlayerRatings(playerId);
    if (ratings.isEmpty) {
      return {
        'attack': 5.0,
        'defense': 5.0,
        'setting': 5.0,
        'reception': 5.0,
        'serve': 5.0,
        'block': 5.0,
      };
    }

    double avgAttack =
        ratings.map((r) => r.attack).reduce((a, b) => a + b) / ratings.length;
    double avgDefense =
        ratings.map((r) => r.defense).reduce((a, b) => a + b) / ratings.length;
    double avgSetting =
        ratings.map((r) => r.setting).reduce((a, b) => a + b) / ratings.length;
    double avgReception =
        ratings.map((r) => r.reception).reduce((a, b) => a + b) /
            ratings.length;
    double avgServe =
        ratings.map((r) => r.serve).reduce((a, b) => a + b) / ratings.length;
    double avgBlock =
        ratings.map((r) => r.block).reduce((a, b) => a + b) / ratings.length;

    return {
      'attack': avgAttack,
      'defense': avgDefense,
      'setting': avgSetting,
      'reception': avgReception,
      'serve': avgServe,
      'block': avgBlock,
    };
  }
}
