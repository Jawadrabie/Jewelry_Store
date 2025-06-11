import 'package:fake_store_app/screens/auth/login_screen.dart';
import 'package:fake_store_app/screens/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/favorite/favorite_cubit.dart';
import 'cubit/theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/store_repository.dart';
import 'screens/home/home_screen.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storeRepository = StoreRepository();
  final authRepository = AuthRepository();

  final favoriteCubit = FavoriteCubit();
  final cartCubit = CartCubit();

  await favoriteCubit.loadFavorites();
  await cartCubit.loadCart();

  // تحسين المزامنة لتكون في الخلفية
  WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
    syncLocalDataWithServer(favoriteCubit, cartCubit);
  });

  runApp(
    RepositoryProvider.value(
      value: storeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => favoriteCubit),
          BlocProvider(create: (_) => cartCubit),
          BlocProvider(create: (_) => AuthCubit(authRepository)),
        ],
        child: const FakeStoreApp(),
      ),
    ),
  );
}

// تحسين الدالة لتجنب تجميد الواجهة
Future<void> syncLocalDataWithServer(
    FavoriteCubit favoriteCubit, CartCubit cartCubit) async {
  try {
    final client = http.Client();

    // مزامنة المفضلة
    final favoriteFutures = favoriteCubit.state.map((product) {
      return client.post(
        Uri.parse('https://jewelrystore-production.up.railway.app/api/addfavorite'),
        body: {'ProductID': product.productId.toString()},
      );
    }).toList();

    // مزامنة السلة
    final cartFutures = cartCubit.state.map((product) {
      return client.post(
        Uri.parse('https://jewelrystore-production.up.railway.app/api/addorder'),
        body: {'ProductID': product.productId.toString()},
      );
    }).toList();

    await Future.wait([...favoriteFutures, ...cartFutures]);
    client.close();
  } catch (e) {
    print('خطأ في مزامنة البيانات مع الخادم: $e');
  }
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