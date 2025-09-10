import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit(this.authRepository) : super(AuthInitial()) {
    _loadSavedUser();
  }

  Future<void> _loadSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');

      if (token != null && name != null && email != null) {
        final user = UserModel(
          name: name,
          email: email,
          token: token,
        );
        emit(AuthSuccess(user));
        print('User loaded from storage: $name');
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      print('Error loading saved user: $e');
      emit(AuthInitial());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.login(email, password);
      emit(AuthSuccess(user));

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', user.token ?? '');
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
      print('Saved token: ${prefs.getString('token')}');

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
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_email', user.email);
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('No token found');
      }
      print(AuthLoading());
      await authRepository.logout(token);
      // إزالة بيانات المستخدم فقط وليس السلة والمفضلة
      await prefs.remove('token');
      await prefs.remove('user_name');
      await prefs.remove('user_email');
      emit(AuthLoggedOut());
    } catch (e) {
      print(AuthLoggedOut());
      print(e.toString());
      emit(AuthFailure(e.toString()));
    }
  }
}
