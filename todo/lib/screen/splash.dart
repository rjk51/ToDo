import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {

    Color splashColor =
    Theme.of(context).brightness == Brightness.dark
      ? Colors.black
      : Colors.white;

    Color textColor =
    Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black;

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });

    return Scaffold(
      backgroundColor: splashColor,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/todol1.png',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              'TODO',
              style: GoogleFonts.jacquesFrancoisShadow(
                fontSize: 40,
                color: textColor,
              ),
            ),
          ]
        ),
      ),
    );
  }
}
