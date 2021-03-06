import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  const HealthBar({
    Key key,
    @required this.health,
    @required this.maxHealth,
  }) : super(key: key);

  final double health;
  final double maxHealth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Stack(
        children: [
          ClipRRect(
            clipper: BarClipper(health / maxHealth),
            child: _buildBar(),
          ),
          Opacity(opacity: 0.3, child: _buildBar())
        ],
      ),
    );
  }

  Container _buildBar() {
    const height = 24.0;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.red,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.red,
            Colors.red.withAlpha(210),
            Colors.red.withAlpha(120),
            Colors.red.withAlpha(210),
            Colors.red,
          ],
        ),
        border: Border.all(
          color: Colors.red.withAlpha(50),
          width: 5,
        ),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

class BarClipper extends CustomClipper<RRect> {
  BarClipper(this.value) : assert(value >= 0 && value <= 1);
  final double value;

  double width = -1;

  @override
  RRect getClip(Size size) {
    width = size.width;

    final rect = RRect.fromLTRBR(
      0,
      0,
      width * value,
      size.height,
      Radius.zero,
    );

    return rect;
  }

  @override
  bool shouldReclip(BarClipper oldClipper) {
    return width != oldClipper.width;
  }
}
