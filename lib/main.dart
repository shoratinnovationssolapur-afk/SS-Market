import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this
import 'screens/get_started.dart';

void main() async {
  // 1. Ensure Flutter is ready to talk to native code
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase (This is mandatory)
  await Firebase.initializeApp();

  runApp(const MarketHubApp());
}

class MarketHubApp extends StatelessWidget {
  const MarketHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        // Using a deep navy/black for that premium stock market feel
        scaffoldBackgroundColor: const Color(0xFF02101A),
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        ),
      ),
      // Starting with GetStarted as the entry point
      home: const GetStartedScreen(),
    );
  }
}