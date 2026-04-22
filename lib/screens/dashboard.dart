import 'package:flutter/material.dart';
import 'stock_details.dart';
import 'insights.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF010B13),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF041C2C), Color(0xFF010B13), Color(0xFF052D3E)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              _buildHeader(),
              const SizedBox(height: 25),
              _buildCurrencyRow(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(_create3DRoute(const InsightsScreen()));
                },
                child: const Text(
                  "\$27,450.50",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              _buildBarChart(context),
              const SizedBox(height: 30),
              _buildActionButtons(context),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Famous Stocks",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("See All", style: TextStyle(color: Colors.white54)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildStockListItem(
                context,
                "Apple Inc",
                "Apple",
                "12350.50\$",
                "+15.50\$",
                Icons.apple,
                Colors.greenAccent,
                "apple_hero",
              ),
              _buildStockListItem(
                context,
                "Microsoft",
                "MSFT",
                "2350.50\$",
                "-15.50\$",
                Icons.grid_view_rounded,
                Colors.redAccent,
                "msft_hero",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=leo'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hello", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                const Text(
                  "Leo Culhane",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Stack(
            children: [
              const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyRow() {
    return Row(
      children: [
        _currencyItem("USD", "27,450.50", Icons.flag, Colors.blueAccent),
        const SizedBox(width: 15),
        _currencyItem("EUR", "15,550.50", Icons.flag_circle, Colors.indigoAccent),
        const SizedBox(width: 15),
        _currencyItem("GBP", "10,350.50", Icons.flag_circle_outlined, Colors.deepPurpleAccent),
      ],
    );
  }

  Widget _currencyItem(String code, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(code, style: const TextStyle(fontSize: 10, color: Colors.white54)),
              Text(value, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_create3DRoute(const InsightsScreen()));
      },
      child: SizedBox(
        height: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _bar(0.4, "JAN"),
            _bar(0.6, "FEB"),
            _bar(0.5, "MAR"),
            _bar(0.8, "APR"),
            _bar(1.0, "MAY", isHighlighted: true),
            _bar(0.7, "JUN"),
            _bar(0.6, "JUL"),
          ],
        ),
      ),
    );
  }

  Widget _bar(double heightFactor, String label, {bool isHighlighted = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isHighlighted)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("\$7520", style: TextStyle(color: Colors.white, fontSize: 10)),
          ),
        const SizedBox(height: 5),
        Container(
          width: 35,
          height: 140 * heightFactor,
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.cyanAccent.withOpacity(0.8) : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            boxShadow: isHighlighted
                ? [BoxShadow(color: Colors.cyanAccent.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)]
                : [],
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 10)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionButton(Icons.add_circle_outline, "Top Up", () {}),
        _actionButton(Icons.account_balance_wallet_outlined, "Receive", () {}),
        _actionButton(Icons.send_outlined, "Send", () {}),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return _ThreeDButton(
      onTap: onTap,
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildStockListItem(
      BuildContext context,
      String title,
      String subtitle,
      String price,
      String change,
      IconData icon,
      Color changeColor,
      String heroTag,
      ) {
    return _ThreeDButton(
      onTap: () {
        Navigator.of(context).push(_create3DRoute(StockDetailsScreen(
          name: title,
          sym: subtitle,
          price: price,
          change: change,
          icon: icon,
          heroTag: heroTag,
          isLoss: change.contains("-"),
        )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 13)),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(change, style: TextStyle(color: changeColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Route _create3DRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final rotateAnim = Tween<double>(begin: 0.4, end: 0.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.002)
                ..rotateY(rotateAnim.value)
                ..translate(animation.value * 20.0, 0.0, -animation.value * 100.0),
              alignment: Alignment.centerRight,
              child: Opacity(
                opacity: animation.value,
                child: child,
              ),
            );
          },
          child: child,
        );
      },
    );
  }
}

class _ThreeDButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _ThreeDButton({required this.child, required this.onTap});

  @override
  State<_ThreeDButton> createState() => _ThreeDButtonState();
}

class _ThreeDButtonState extends State<_ThreeDButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}