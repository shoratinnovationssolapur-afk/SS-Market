import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/get_started.dart'; // Fixed path
import 'screens/login.dart';       // Fixed path
import 'screens/dashboard.dart';   // Fixed path

void main() => runApp(const MarketHubApp());

class MarketHubApp extends StatelessWidget {
  const MarketHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF02101A),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const GetStartedScreen(),
    );
  }
}