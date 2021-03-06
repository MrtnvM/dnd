import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class EnemyData {
  EnemyData({
    this.id,
    @required this.name,
    @required this.image,
    @required this.currentHealth,
    @required this.maxHealth,
    @required this.armor,
  });

  final String id;
  final String name;
  final Uint8List image;
  final double currentHealth;
  final double maxHealth;
  final double armor;
}
