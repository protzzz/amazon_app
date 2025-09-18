import 'package:amazon_clone_app/core/services/shared_preferences_service.dart';
import 'package:amazon_clone_app/features/auth/repository/auth_remote_repository.dart';
import 'package:amazon_clone_app/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authRemoteRepository = AuthRemoteRepository();
  final spService = SharedPreferencesService();

  void signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      emit(AuthLoading());

      await authRemoteRepository.signUp(
        email: email,
        password: password,
        name: name,
      );

      emit(AuthSignUp());
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  void login({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

      final user = await authRemoteRepository.login(
        email: email,
        password: password,
      );

      if (user.token.isNotEmpty) {
        await spService.setToken(user.token);
      }

      emit(AuthLoggedIn(user));
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }

  void getUserData() async {
    try {
      emit(AuthLoading());

      final user = await authRemoteRepository.getUserData();

      if (user != null) {
        emit(AuthLoggedIn(user));
      } else {
        emit(AuthInitial());
      }
    } catch (error) {
      emit(AuthError(error.toString()));
    }
  }
}
