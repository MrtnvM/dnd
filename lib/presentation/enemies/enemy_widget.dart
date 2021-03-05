import 'package:flutter/material.dart';

class EnemyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.8;
    final width = height * 0.6;

    return Container(
      height: height,
      width: width,
      child: Stack(
        children: [
          _buildEnemy(),
          _buildHealthBar(),
        ],
      ),
    );
  }

  Widget _buildHealthBar() {
    const maxHealth = 14;
    const currentHealth = 8;
    const height = 28.0;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red,
              Colors.red.withAlpha(130),
              Colors.red.withAlpha(50),
              Colors.red.withAlpha(130),
              Colors.red,
            ],
          ),
          border: Border.all(
            color: Colors.red.withAlpha(50),
            width: 5,
          ),
          borderRadius: BorderRadius.circular(height / 2),
        ),
      ),
    );
  }

  Widget _buildEnemy() {
    return Positioned.fill(
      top: 0,
      child: Image.network(
        'https://firebasestorage.googleapis.com/v0/b/dungeon-and-dragons-53283.appspot.com/o/magician.jpg?alt=media&token=827d3c1d-2f1a-4957-9fc5-cd8b3eae1a90',
      ),
    );
  }
}
