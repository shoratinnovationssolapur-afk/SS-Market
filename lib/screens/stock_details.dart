import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockDetailsScreen extends StatelessWidget {
  final String name, sym, price, change, heroTag;
  final IconData icon;
  final bool isLoss;

  const StockDetailsScreen({
    super.key, required this.name, required this.sym, required this.price,
    required this.change, required this.icon, required this.heroTag, required this.isLoss
  });

  @override
  Widget build(BuildContext context) { // This is the missing build method
    return Scaffold(
      backgroundColor: const Color(0xFF02101A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            _buildChartContainer(), // Now this will be referenced
            // Add your other widgets here
          ],
        ),
      ),
    );
  }

  // Ensure this method is INSIDE the StockDetailsScreen class brackets
  Widget _buildChartContainer() {
    return Container(
      height: 250,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 2), FlSpot(3, 5)],
              isCurved: true,
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}