import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }
}
