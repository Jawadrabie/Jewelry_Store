import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/favorite/favorite_cubit.dart';
import 'cubit/theme.dart';
import 'data/repositories/store_repository.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storeRepository = StoreRepository(); // ✅

  final favoriteCubit = FavoriteCubit();
  final cartCubit = CartCubit();

  await favoriteCubit.loadFavorites();
  await cartCubit.loadCart();

  runApp(
    RepositoryProvider.value( // ✅ لف التطبيق لتوفير الـ repository
      value: storeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => favoriteCubit),
          BlocProvider(create: (_) => cartCubit),
        ],
        child: const FakeStoreApp(),
      ),
    ),
  );
}



class FakeStoreApp extends StatelessWidget {
  const FakeStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
            title: 'Fake Store',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            home: const HomeScreen(),
          );
        },

    );
  }
}
