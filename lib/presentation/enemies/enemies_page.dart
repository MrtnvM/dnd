import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/presentation/enemies/enemy_page.dart';
import 'package:dnd/presentation/enemies/enemy_widget.dart';
import 'package:dnd/widgets/containers/grid_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnemiesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnemyController>(
      initState: (_) => EnemyController.to.getEnemies(),
      builder: (controller) => GridEditor<Enemy>(
        title: 'Враги',
        items: controller.enemies,
        loadItems: () => controller.getEnemies(),
        deleteItem: (id) => controller.deleteEnemy(id),
        controllerStatus: controller.status,
        goToItemEditor: (e) => Get.to(() => EnemyEditorPage(enemy: e)),
        goToItem: (e) => Get.dialog(
          Material(child: Center(child: EnemyWidget(enemy: e))),
        ),
      ),
    );
  }
}
