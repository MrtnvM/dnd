import 'package:dnd/models/game_object.dart';
import 'package:flutter/foundation.dart';

class Enemy extends GameObject {
  Enemy({
    @required this.id,
    @required this.name,
    @required this.imageUrl,
    @required this.currentHealth,
    @required this.maxHealth,
    @required this.armor,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double currentHealth;
  final double maxHealth;
  final double armor;

  static Enemy fromJson(Map<String, dynamic> json) {
    return Enemy(
      id: json["id"],
      name: json['name'],
      imageUrl: json['imageUrl'],
      currentHealth: json['currentHealth'],
      maxHealth: json['maxHealth'],
      armor: json['armor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'currentHealth': currentHealth,
      'maxHealth': maxHealth,
      'armor': armor,
    };
  }

  Enemy copyWith({
    String id,
    String name,
    String imageUrl,
    double currentHealth,
    double maxHealth,
    double armor,
  }) {
    return Enemy(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      currentHealth: currentHealth ?? this.currentHealth,
      maxHealth: maxHealth ?? this.maxHealth,
      armor: armor ?? this.armor,
    );
  }
}
