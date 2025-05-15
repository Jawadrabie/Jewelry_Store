import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/theme.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorites_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('الإعدادات')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
