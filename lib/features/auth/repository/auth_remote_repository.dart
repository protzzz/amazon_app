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
        Uri.parse('$uri/api/signup'),
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
      throw e.toString();
    }
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/api/signin'),
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

  /*
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserModel user = UserModel(
        id: 'id',
        name: name,
        email: email,
        password: password,
        address: 'address',
        type: 'type',
        token: 'token',
      );

      final res = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackbar(
            context,
            'Account created! Now login, please.',
          );
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
  */

  /*
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      // print(res.body);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          await spServie.setToken(jsonDecode(res.body)['token']);
        },
      );
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }
  */
}
