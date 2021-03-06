import 'dart:convert';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/models/enemies/enemy_data.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class EnemyController extends GetxController with StateMixin<List<Enemy>> {
  final _enemiesCollection = FirebaseFirestore.instance.collection('enemies');
  var enemies = <Enemy>[];

  static EnemyController get to => Get.find();

  Future<Enemy> getEnemy(String id) async {
    if (id == null) {
      return null;
    }

    final doc = await _enemiesCollection.doc(id).get();
    final enemy = Enemy.fromJson(doc.data());
    return enemy;
  }

  Stream<Enemy> subscribeToEnemy(String id) {
    return _enemiesCollection
        .doc(id)
        .snapshots()
        .where((s) => s.data() != null)
        .map((s) => Enemy.fromJson(s.data()));
  }

  Future<void> updateEnemy(EnemyData enemy, {Enemy existingEnemy}) async {
    final storage = Get.find<StorageService>();

    final imageUrl = enemy.image != null
        ? await storage.uploadImage(enemy.id, enemy.image)
        : existingEnemy?.imageUrl;

    if (imageUrl == null) {
      Get.snackbar('Эй, бро!', 'Выбери изображение локации сначала');
      return;
    }

    final enemyModel = Enemy(
      id: existingEnemy?.id ?? Uuid().v4(),
      name: enemy.name,
      imageUrl: imageUrl,
      armor: enemy.armor,
      currentHealth: enemy.currentHealth,
      maxHealth: enemy.maxHealth,
    );

    final docRef = _enemiesCollection.doc(enemyModel.id);
    final doc = await docRef.get();
    final enemyJson = enemyModel.toJson();

    if (doc.exists) {
      await docRef.update(enemyJson);
    } else {
      await docRef.set(enemyJson);
    }

    getEnemies();
  }

  Future<void> deleteEnemy(String id) async {
    await _enemiesCollection.doc(id).delete();
  }

  Future<List<Enemy>> getEnemies() async {
    change(enemies, status: RxStatus.loading());

    try {
      final snapshots = await _enemiesCollection.get();
      enemies = snapshots.docs //
          .map((s) => s.data())
          .map((l) => Enemy.fromJson(l))
          .toList();

      change(enemies, status: RxStatus.success());
    } catch (error) {
      print(error);
      change(enemies, status: RxStatus.error());
    }

    return enemies;
  }

  void backupEnemies(List<Location> enemies) {
    final jsonData = enemies.map((l) => l.toJson()).toList();
    final text = json.encode(jsonData);
    final bytes = utf8.encode(text);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'enemies.json';
    html.document.body.children.add(anchor);

    anchor.click();

    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
