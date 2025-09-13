import 'package:flutter/material.dart';

import '../presentation/screens/auth/login_screen_.dart';

class AppDialogs {
  static void showLoginRequiredDialog({
    required BuildContext context,
    required VoidCallback onLoginPressed,
    String title = 'تسجيل الدخول مطلوب',
    String content = 'الرجاء تسجيل الدخول للمتابعة.',
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('رجوع'),
          ),
          TextButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const LoginScreen()),
              // );
              onLoginPressed();
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}
