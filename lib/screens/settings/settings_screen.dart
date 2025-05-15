import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../cubit/theme.dart';
import '../auth/login_screen.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorites_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? userEmail;
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('user_email');
      userName = prefs.getString('user_name');
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
    await prefs.remove('user_name');
    setState(() {
      userEmail = null;
      userName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ عرض اسم المستخدم والبريد إذا كان مسجل دخول
            if (userEmail != null && userName != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('مرحباً، $userName', style: const TextStyle(fontSize: 16)),
                          Text(userEmail!, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            SettingTile(
              icon: Icons.favorite,
              text: 'المفضلة',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            SettingTile(
              icon: Icons.shopping_cart,
              text: 'السلة',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
            ),
            const SizedBox(height: 12),
            SettingTile(
              icon: Icons.brightness_6_rounded,
              text: 'تغيير الثيم',
              trailing: Switch(
                value: isDark,
                onChanged: (val) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              onTap: () {
                context.read<ThemeCubit>().toggleTheme();
              },
            ),
            const SizedBox(height: 12),
            SettingTile(
              icon: userEmail == null ? Icons.login : Icons.logout,
              text: userEmail == null ? 'تسجيل الدخول' : 'تسجيل الخروج',
              onTap: () {
                if (userEmail == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ).then((_) {
                    loadUserData(); // إعادة تحميل البيانات عند الرجوع
                  });
                } else {
                  logout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Widget? trailing;
  final VoidCallback onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.text,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Theme.of(context).colorScheme.primary),
      title: Text(text, style: const TextStyle(fontSize: 18)),
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
    );
  }
}
