import 'package:fake_store_app/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'cubit/add_product/product_add_cubit.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/favorite/favorite_cubit.dart';
import 'cubit/home/home_cubit.dart'; // لو تستخدم HomeCubit
import 'cubit/theme/theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/store_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storeRepository = StoreRepository();
  final authRepository = AuthRepository();

  // إنشاء Cubits مرة واحدة فقط
  final favoriteCubit = FavoriteCubit();
  final cartCubit = CartCubit();
  final authCubit = AuthCubit(authRepository);
  final themeCubit = ThemeCubit();
  final homeCubit = HomeCubit(storeRepository);
  final productAddCubit = ProductAddCubit(storeRepository);

  // Load saved data on app startup
  await favoriteCubit.loadFavorites();
  await cartCubit.loadCart();

  runApp(
    RepositoryProvider.value(
      value: storeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: favoriteCubit),
          BlocProvider.value(value: cartCubit),
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: homeCubit),
          BlocProvider.value(value: productAddCubit), // إضافة HomeCubit هنا
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
          title: 'Jewelry Store',
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
