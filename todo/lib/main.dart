import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/screen/main_screen.dart';
import 'package:todo/screen/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        backgroundColor: Color.fromARGB(255, 168, 171, 172),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
      ),
      primarySwatch: Colors.blue,
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: const Color.fromARGB(255, 32, 39, 41),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.white,
    );

    final darkTheme = ThemeData(
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color.fromARGB(255, 129, 129, 129),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
      ),
      primarySwatch: Colors.blue,
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color.fromARGB(255, 7, 75, 153),
        surface: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo',
      theme: isDarkMode ? darkTheme : lightTheme,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if(snapshot.hasData) {
            return const MainScreen();
          }
          return const AuthScreen();
        }
      ),
    );
  }
}
