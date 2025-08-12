import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cubit/auth/auth_cubit.dart';
import '../../../widgets/buildTextField.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: isDarkMode
                ? null
                : const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF7E0), Color(0xFFFAE091)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Icon(
                        Icons.diamond,
                        size: 70,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back to Jewelry Store',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Please login to continue',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 32),

                      /// Email Field
                      CustomTextField(
                        controller: emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      /// Password Field
                      CustomTextField(
                        controller: passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onPressed: () {
                            setState(() => obscurePassword = !obscurePassword);
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),

                      /// Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    authCubit.login(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: state is AuthLoading
                              ? CircularProgressIndicator(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                )
                              : Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      /// Register Link
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Don't have an account?",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium!.color,
                                ),
                              ),
                              TextSpan(
                                text: ' Sign up',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
