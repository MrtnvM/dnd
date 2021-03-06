import 'package:flutter/foundation.dart';

class Game {
  Game({
    @required this.id,
    @required this.currentLocationId,
    @required this.currentEnemyId,
    @required this.currentHeroId,
  });

  final String id;
  final String currentLocationId;
  final String currentEnemyId;
  final String currentHeroId;

  static Game fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      currentLocationId: json['currentLocationId'],
      currentEnemyId: json['currentEnemyId'],
      currentHeroId: json['currentHeroId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'currentLocationId': currentLocationId,
      'currentEnemyId': currentEnemyId,
      'currentHeroId': currentHeroId,
    };
  }

  Game copyWith({
    String id,
    String currentLocationId,
    String currentEnemyId,
    String currentHeroId,
  }) {
    return Game(
      id: id ?? this.id,
      currentLocationId: currentLocationId ?? this.currentLocationId,
      currentEnemyId: currentEnemyId ?? this.currentEnemyId,
      currentHeroId: currentHeroId ?? this.currentHeroId,
    );
  }
}
