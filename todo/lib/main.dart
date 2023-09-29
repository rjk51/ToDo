import 'package:flutter/material.dart';
import 'package:todo/screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
          brightness: Brightness.dark,
          surface: const Color(0xffd88e43),
        ),
        scaffoldBackgroundColor: const Color(0xffd88e43),
      ),
      home: const SplashScreen(),
    );
  }
}