import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(email, password);
      emit(AuthSuccess(user));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token ?? '');
      await prefs.setString('name', user.name);
      await prefs.setString('email', user.email);
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phone,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.register(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
      );
      emit(AuthSuccess(user));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token ?? '');
      await prefs.setString('name', user.name);
      await prefs.setString('email', user.email);
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout(String token) async {
    emit(AuthLoading());
    try {
      await authRepository.logout(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('email');
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

}
