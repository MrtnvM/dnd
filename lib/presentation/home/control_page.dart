import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/controllers/game_controller.dart';
import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/widgets/containers/grid_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

const locationsIndex = 0;
const enemiesIndex = 1;

class ControlPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentTabIndex = useState(locationsIndex);

    final buildEditor = {
          locationsIndex: () => ChangeLocationPage(),
          enemiesIndex: () => ChangeEnemyPage(),
        }[currentTabIndex.value] ??
        () => Container();

    return Scaffold(
      body: buildEditor(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTabIndex.value,
        onTap: (i) => currentTabIndex.value = i,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.place),
            label: 'Выбрать локацию',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dangerous),
            label: 'Выбрать врага',
          ),
        ],
      ),
    );
  }
}

class ChangeLocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      initState: (_) => LocationController.to.getLocations(),
      builder: (controller) => GridEditor<Location>(
        title: 'Переключение локации',
        items: controller.locations,
        loadItems: () => controller.getLocations(),
        deleteItem: null,
        controllerStatus: controller.status,
        goToItemEditor: null,
        goToItem: (l) => GameController.to.selectLocation(l.id),
      ),
    );
  }
}

class ChangeEnemyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EnemyController>(
      initState: (_) => EnemyController.to.getEnemies(),
      builder: (controller) => GridEditor<Enemy>(
        title: 'Враги',
        items: controller.enemies,
        loadItems: () => controller.getEnemies(),
        deleteItem: null,
        controllerStatus: controller.status,
        goToItemEditor: null,
        goToItem: (e) => GameController.to.selectEnemy(e.id),
      ),
    );
  }
}
