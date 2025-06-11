import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cubit/auth/auth_cubit.dart';
import 'auth/login_screen.dart';
import 'auth/login_screen_.dart';

class HomeScreenn extends StatelessWidget {
  const HomeScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString('token') ?? '';

              context.read<AuthCubit>().logout(token);
            },

          ),
        ],
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: const Center(
          child: Text(
            'You are logged in!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
