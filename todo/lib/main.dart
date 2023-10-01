import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/screen/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Brightness getSystemBrightness(BuildContext context) {
    return MediaQuery.of(context).platformBrightness;
  }

  @override
  Widget build(BuildContext context) {
    final systemBrightness = getSystemBrightness(context);
    final isDarkMode = systemBrightness == Brightness.dark;

    final lightTheme = ThemeData(
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 123, 18, 141),
      ),
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 7, 75, 153),
        surface: Colors.purple,
      ),
      scaffoldBackgroundColor: Colors.purple,
    );

    final darkTheme = ThemeData(
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 7, 75, 153),
        surface: const Color.fromARGB(255, 0, 0, 0),
      ),
      scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: isDarkMode ? darkTheme : lightTheme,
      home: const SplashScreen(),
    );
  }
}
