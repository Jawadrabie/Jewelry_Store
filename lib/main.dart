import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/cart/cart_cubit.dart';
import 'cubit/favorite/favorite_cubit.dart';
import 'cubit/home/home_cubit.dart';  // لو تستخدم HomeCubit
import 'cubit/theme/theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/store_repository.dart';
import 'screens/home/home_screen.dart';
import 'package:http/http.dart' as http;

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

  // تحميل البيانات مرة واحدة فقط قبل تشغيل التطبيق
  //await
   favoriteCubit.loadFavorites();
   cartCubit.loadCart();
   homeCubit.loadHomeData();

  // مزامنة البيانات في الخلفية بعد بناء الإطار الأول
  WidgetsBinding.instance.addPostFrameCallback((_) {
    syncLocalDataWithServer(favoriteCubit, cartCubit);
  });

  runApp(
    RepositoryProvider.value(
      value: storeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: themeCubit),
          BlocProvider.value(value: favoriteCubit),
          BlocProvider.value(value: cartCubit),
          BlocProvider.value(value: authCubit),
          BlocProvider.value(value: homeCubit),  // إضافة HomeCubit هنا
        ],
        child: const FakeStoreApp(),
      ),
    ),
  );
}

// دالة مزامنة البيانات مع الخادم
Future<void> syncLocalDataWithServer(
    FavoriteCubit favoriteCubit, CartCubit cartCubit) async {
  try {
    final client = http.Client();

    final favoriteFutures = favoriteCubit.state.map((product) {
      return client.post(
        Uri.parse('https://jewelrystore-production-ec35.up.railway.app/api/addfavorite'),
        body: {'ProductID': product.productId.toString()},
      );
    }).toList();

    final cartFutures = cartCubit.state.map((product) {
      return client.post(
        Uri.parse('https://jewelrystore-production-ec35.up.railway.app/api/addorder'),
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
