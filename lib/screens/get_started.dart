import 'package:flutter/material.dart';
import 'login.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.5, -0.6),
                radius: 1.2,
                colors: [Color(0xFF0C3D5A), Color(0xFF02101A)],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text("Invest in\nyour future",
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                  const SizedBox(height: 20),
                  const Text("Track your assets with 3D precision.",
                      style: TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 50),
                  _buildGlobeButton(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobeButton(BuildContext context) {
    return Center(
      child: Hero(
        tag: 'globe_morph',
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          child: Container(
            height: 65,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Color(0xFF00D2FF), Color(0xFF3A7BD5)]),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D2FF).withValues(alpha: 0.4),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: const Center(
              child: Text("Get Started",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
            ),
          ),
        ),
      ),
    );
  }
}
