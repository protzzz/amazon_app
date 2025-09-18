import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  Future<void> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
  }

  Future<String?> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('x-auth-token');
  }
}
