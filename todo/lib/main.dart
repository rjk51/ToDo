import 'package:flutter/material.dart';
import 'package:todo/screen/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/firebase_options.dart';
//import 'package:todo/screen/splash.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: const MainScreen(),
    );
  }
}
