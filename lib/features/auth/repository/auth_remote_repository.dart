import 'dart:convert';
import 'package:amazon_clone_app/core/constants/api_excesption.dart';
import 'package:amazon_clone_app/core/constants/global_variables.dart';
import 'package:amazon_clone_app/core/services/shared_preferences_service.dart';
import 'package:amazon_clone_app/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {
  final spServie = SharedPreferencesService();

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), -1);
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/auth/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      // if (res.statusCode != 200) {
      //   throw jsonDecode(res.body)['error'];
      // }

      print(res.body);

      if (res.statusCode == 200) {
        return UserModel.fromJson(res.body);
      } else {
        final decoded = jsonDecode(res.body);
        final errorMessage =
            decoded['error'] ??
            decoded['message'] ??
            'Unknown error';

        throw ApiException(errorMessage, res.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), -1);
    }
  }

  Future<UserModel?> getUserData() async {
    try {
      final token = await spServie.getToken();

      // if no token (user not logged in) -> null
      if (token == null) return null;

      final res = await http.post(
        Uri.parse('$uri/auth/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      print(res.body);

      if (res.statusCode != 200 || jsonDecode(res.body) == false) {
        return null;
      }

      final userResponse = await http.get(
        Uri.parse('$uri/auth'),
        headers: <String, String>{
          'Content_Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (userResponse.statusCode == 200) {
        return UserModel.fromJson(userResponse.body);
      } else {
        final decoded = jsonDecode(res.body);
        final errorMessage =
            decoded['error'] ??
            decoded['message'] ??
            'Unknown error';

        throw ApiException(errorMessage, res.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(e.toString(), -1);
    }
  }
}
