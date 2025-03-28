import 'package:bastarts_studio_users/constants/colors.dart';
import 'package:bastarts_studio_users/presentation/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';

//TODO don't forget the CORS policy
//TODO don't forget security rules
void main() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(
          builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
            TargetPlatform.values,
            value: (dynamic _) => const ZoomPageTransitionsBuilder(),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black, primary: Colors.black, error: MyColors.bastRed),
        fontFamily: 'BebasNeue',
        // primaryColor: Colors.white,
        textTheme: TextTheme(
          labelMedium: TextStyle(color: Colors.white, fontSize: 48),
          labelLarge: TextStyle(color: Colors.black, fontSize: 48, height: 1),
          headlineMedium: TextStyle(color: Colors.white, fontSize: 24),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 24),
          bodySmall: TextStyle(color: Colors.black, fontSize: 24, height: 1),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            foregroundColor: WidgetStatePropertyAll(Colors.black),
            textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 24, fontFamily: 'BebasNeue')),
            padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 24)),
            shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(2))),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white))),
      ),
      locale: Locale('sl', 'SL'),
      supportedLocales: [Locale('sl')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomeScreen(),
    );
  }
}
