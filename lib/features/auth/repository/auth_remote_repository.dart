import 'dart:convert';
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
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['error'];
      }

      print(res.body);

      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
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
