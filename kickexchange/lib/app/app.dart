import 'package:flutter/material.dart';
import 'package:kickexchange/controllers/auth_Controller.dart';
import 'package:kickexchange/controllers/category_controller.dart';
import 'package:kickexchange/controllers/navigation_provider.dart';
import 'package:kickexchange/controllers/product_controller.dart';
import 'package:kickexchange/controllers/profile_controller.dart';
import 'package:kickexchange/core/preferences/colors.dart';
import 'package:kickexchange/views/auth_page.dart';
import 'package:kickexchange/views/detail_product_page.dart';
import 'package:kickexchange/views/edit_form_page.dart';
import 'package:kickexchange/views/homepage.dart';
import 'package:kickexchange/views/navigation_page.dart';
import 'package:kickexchange/views/splash_screen.dart';
import 'package:provider/provider.dart';

class KickExchangeApp extends StatelessWidget {
  const KickExchangeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => ProductController()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
        ChangeNotifierProvider(create: (_) => CategoryController()),
      ],
      child: MaterialApp(
          title: "KickExchangeApp",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'montserrat',
            useMaterial3: true,
            colorSchemeSeed: AppColors.black,
            scaffoldBackgroundColor: Color(0xFFF9F9F9),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/navigation': (context) => NavigationPage(),
            '/auth': (context) => AuthPage(),
            '/home': (context) => Homepage(),
            '/productForm': (context) => EditFormPage(),
            '/productDetail': (context) => DetailProductPage(),
          }),
    );
  }
}
