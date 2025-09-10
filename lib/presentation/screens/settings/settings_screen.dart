import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/auth/auth_cubit.dart';
import '../../../cubit/theme/theme.dart';
import '../auth/login_screen_.dart';
import '../cart/cart_screen.dart';
import '../favorites/favorites_screen.dart';
import '../offers/offers_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedOut) {
          setState(() {
            userEmail = null;
            userName = null;
          });
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${state.message}')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(title: const Text('Settings')),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (userEmail != null && userName != null)
                    Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person,
                              size: 40, color: colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome, $userName',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  userEmail!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color:
                                        colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SettingTile(
                    icon: Icons.favorite,
                    text: 'Favorites',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const FavoritesScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingTile(
                    icon: Icons.shopping_cart,
                    text: 'Cart',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingTile(
                    icon: Icons.local_offer,
                    text: 'Offers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const OffersScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SettingTile(
                    icon: Icons.brightness_6_rounded,
                    text: 'Theme',
                    trailing: Switch(
                      value: isDark,
                      onChanged: (_) =>
                          context.read<ThemeCubit>().toggleTheme(),
                      activeColor: colorScheme.primary,
                    ),
                    onTap: () => context.read<ThemeCubit>().toggleTheme(),
                  ),
                  const SizedBox(height: 12),
                  SettingTile(
                    icon: userEmail == null ? Icons.login : Icons.logout,
                    text: userEmail == null ? 'Login' : 'Logout',
                    trailing: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : null,
                    onTap: () {
                      if (userEmail == null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ).then((_) => loadUserData());
                      } else {
                        context.read<AuthCubit>().logout();
                      }
                    },
                  ),
                ],
              ),
            );
          },
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      leading: Icon(icon, size: 28, color: colorScheme.primary),
      title: Text(
        text,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ),
      ),
      trailing: trailing ??
          Icon(Icons.arrow_forward_ios, size: 18, color: colorScheme.onSurface),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: colorScheme.surface.withOpacity(0.05),
    );
  }
}
