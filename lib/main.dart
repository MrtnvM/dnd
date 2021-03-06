import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/presentation/dnd_app.dart';
import 'package:dnd/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  await Firebase.initializeApp();

  Get.put(StorageService());
  Get.put(LocationController());
  Get.put(EnemyController());

  runApp(DndApp());
}
