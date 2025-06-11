import 'package:fake_store_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/auth/auth_cubit.dart';
import '../home/home_screen.dart'; // Assuming this is your home screen

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
    // Assuming AuthCubit is provided higher up in the widget tree
    final authCubit = context.read<AuthCubit>();

    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // After successful login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          } else if (state is AuthFailure) {
            // Display error message
            print(state.message);
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                // Colors adjusted to precisely match the image's background gradient
                colors: [Color(0xFFFFF7E0), Color(0xFFFAE091)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Diamond icon
                    Icon(
                      Icons.diamond, // Using a diamond icon
                      size: 70, // Adjust size to match image
                      color: const Color(0xFF78D7E0), // Light blue color for the diamond
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Welcome Back to Jewelry Store',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37), // Golden color for the title
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please login to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54, // Darker grey for subtitle
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
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
                    // SizedBox height to control spacing below error message
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey.shade600, // Icon color to match subtle look
                        ),
                        onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    // SizedBox height to control spacing below error message
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE4B55E), // Button color matched to image
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
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
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : const Text(
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to the registration screen
                        // Replace RegisterScreen() with your actual RegisterScreen widget
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      },
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Don\'t have an account?',
                              style: TextStyle(color: Colors.black54), // Darker grey
                            ),
                            TextSpan(
                              text: ' Sign up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4C8BF5), // Blue color for "Sign up"
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator, // Validator is used for error messages
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black.withOpacity(0.7), // Color for the label text
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black54, // Color for the hint text
        ),
        filled: true,
        fillColor: const Color(0xFFFEFCF2), // Card background color for the text field
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        // Borders when error or focused, otherwise no visible border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // Default no border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none, // No border when enabled
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0), // Red border when focused
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0), // Red border for error state
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 1.0), // Red border for focused error state
        ),
        suffixIcon: suffixIcon,
        errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 12), // Error text style
      ),
    );
  }
}