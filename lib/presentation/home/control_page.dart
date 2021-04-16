import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/controllers/game_controller.dart';
import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/widgets/containers/grid_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

const locationsIndex = 0;
const enemiesIndex = 1;

class ControlPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentTabIndex = useState(locationsIndex);
    final healthController = useTextEditingController();
    final armorController = useTextEditingController();

    final buildEditor = {
          locationsIndex: () => ChangeLocationPage(),
          enemiesIndex: () => ChangeEnemyPage(),
        }[currentTabIndex.value] ??
        () => Container();

    useEffect(() {
      final gameController = Get.find<GameController>();

      gameController.addListener(() {
        healthController.text =
            gameController.currentEnemy.value?.currentHealth.toString();

        armorController.text =
            gameController.currentEnemy.value?.armor.toString();
      });
      return null;
    }, []);

    return Scaffold(
      body: Column(children: [
        Expanded(
          child: buildEditor(),
        ),
        Container(
          width: double.infinity,
          height: 80,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => GameController.to.selectEnemy(null),
                child: Text('Сбросить монстра'),
              ),
              Expanded(
                child: GetBuilder<GameController>(
                  builder: (controller) => Row(
                    children: [
                      Expanded(
                        child: _InputField(
                          title: 'Здоровье',
                          controller: healthController,
                          onlyDigits: true,
                        ),
                      ),
                      Expanded(
                        child: _InputField(
                          title: 'Броня',
                          controller: armorController,
                          onlyDigits: true,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final armor = double.parse(armorController.text);
                          final health = double.parse(healthController.text);
                          GameController.to.updateEnemy(health, armor);
                        },
                        child: Text('Обновить показатели врага'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
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

class _InputField extends StatelessWidget {
  const _InputField({
    Key key,
    @required this.title,
    @required this.controller,
    this.onlyDigits = false,
  }) : super(key: key);

  final String title;
  final TextEditingController controller;
  final bool onlyDigits;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: title),
        keyboardType: onlyDigits ? TextInputType.number : TextInputType.text,
        inputFormatters: <TextInputFormatter>[
          if (onlyDigits) FilteringTextInputFormatter.digitsOnly
        ],
      ),
    );
  }
}
