import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/presentation/enemies/armor_indicator.dart';
import 'package:dnd/presentation/enemies/health_bar.dart';
import 'package:dnd/presentation/enemies/health_indicator.dart';
import 'package:flutter/material.dart';

class EnemyWidget extends StatelessWidget {
  const EnemyWidget({Key key, @required this.enemy}) : super(key: key);

  final Enemy enemy;

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
          HealthBar(
            health: enemy.currentHealth,
            maxHealth: enemy.maxHealth,
          ),
          _buildHealthIndicator(),
          _buildArmorIndicator(),
        ],
      ),
    );
  }

  Widget _buildEnemy() {
    return Positioned.fill(
      top: 0,
      child: Image.network(enemy.imageUrl),
    );
  }

  Widget _buildHealthIndicator() {
    return Positioned(
      top: 36,
      left: 16,
      child: HealthIndicator(value: enemy.currentHealth),
    );
  }

  Widget _buildArmorIndicator() {
    return Positioned(
      top: 36,
      right: 16,
      child: ArmorIndicator(value: enemy.armor),
    );
  }
}
