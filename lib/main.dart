import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import './firebase_options.dart';
import './routers/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeConfig = ref.watch(routerProvider);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MaterialApp.router(
          title: 'Flutter Demo',
          theme: FlexThemeData.light(
            scheme: FlexScheme.aquaBlue,
            useMaterial3: true,
            useMaterial3ErrorColors: true,
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.aquaBlue,
            useMaterial3: true,
            useMaterial3ErrorColors: true,
            // textTheme:
            fontFamily: GoogleFonts.lato().fontFamily,
          ),
          themeMode: ThemeMode.system,
          routerConfig: routeConfig,
        );
      },
    );
  }
}
