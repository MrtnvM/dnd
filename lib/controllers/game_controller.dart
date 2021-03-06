import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/models/game/game.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:get/get.dart';

class GameController extends GetxController {
  final gameId = 'game1';
  final currrentGame = Rx<Game>(null);
  final currentEnemy = Rx<Enemy>(null);
  final currentLocation = Rx<Location>(null);
  final _firestore = FirebaseFirestore.instance;

  StreamSubscription _gameSubscription;
  StreamSubscription _enemySubscription;

  DocumentReference get gameRef => FirebaseFirestore.instance //
      .collection('games')
      .doc(gameId);

  @override
  void onInit() {
    super.onInit();

    _gameSubscription = gameRef //
        .snapshots()
        .map((s) => Game.fromJson(s.data()))
        .listen((game) {
      currrentGame.value = game;

      final enemyId = game?.currentEnemyId;
      final locationId = game?.currentLocationId;

      if (currentLocation.value?.id != locationId) {
        if (locationId != null) {
          LocationController.to
              .getLocation(locationId)
              .then((l) => currentLocation.value = l);
        } else {
          currentLocation.value = null;
        }
      }

      if (currentEnemy.value?.id != enemyId) {
        _enemySubscription?.cancel();

        if (enemyId != null) {
          _enemySubscription = EnemyController.to
              .subscribeToEnemy(enemyId)
              .listen((e) => currentEnemy.value = e);
        } else {
          currentEnemy.value = null;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _gameSubscription?.cancel();
    _enemySubscription?.cancel();
  }

  Future<Game> getCurrentGame() async {
    final getGame = () async {
      final docRef = _firestore.collection('games').doc(gameId);
      final doc = await docRef.get();
      final game = Game.fromJson(doc.data());
      return game;
    };

    final game = await getGame();

    final gameObjects = await Future.wait([
      if (game.currentLocationId != null)
        LocationController.to.getLocation(game.currentLocationId),
      if (game.currentEnemyId != null)
        EnemyController.to.getEnemy(game.currentEnemyId),
    ]);

    for (final gameObject in gameObjects) {
      if (gameObject is Location) {
        currentLocation.value = gameObject;
      }

      if (gameObject is Enemy) {
        currentEnemy.value = gameObject;
      }
    }

    currrentGame.value = game;
    return game;
  }

  Future<void> selectLocation(String locationId) async {
    final game = await getCurrentGame();

    if (game.currentLocationId == locationId) {
      return;
    }

    final updatedGame = game.copyWith(
      currentLocationId: locationId,
      currentEnemyId: null,
      currentHeroId: null,
    );

    await updateGame(updatedGame);
  }

  Future<void> selectEnemy(String enemyId) async {
    final game = await getCurrentGame();

    if (game.currentEnemyId == enemyId) {
      return;
    }

    final updatedGame = game.copyWith(
      currentEnemyId: enemyId,
    );

    await updateGame(updatedGame);
  }

  Future<void> updateGame(Game game) async {
    final jsonData = game.toJson();
    await gameRef.update(jsonData);
  }
}
