import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:what_is_my_work/game/models.dart';

class GameStateRepository {
  String _getProfileKey(String username) => 'profile_$username';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonState = jsonEncode(profile.toJson());
    await prefs.setString(_getProfileKey(profile.username), jsonState);
  }

  Future<UserProfile?> loadProfile({required String username}) async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonState = prefs.getString(_getProfileKey(username));

    if (jsonState != null) {
      try {
        final Map<String, dynamic> decodedMap = jsonDecode(jsonState);
        return UserProfile.fromJson(decodedMap);
      } catch (e) {
        // If decoding fails, return null to start a fresh game.
        print('Error decoding saved state for user $username: $e');
        return null;
      }
    }
    return null;
  }
}
