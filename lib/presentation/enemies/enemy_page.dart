import 'package:dnd/controllers/enemy_controller.dart';
import 'package:dnd/hooks/image_hooks.dart';
import 'package:dnd/models/enemies/enemy.dart';
import 'package:dnd/models/enemies/enemy_data.dart';
import 'package:dnd/widgets/utils/drop_focus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class EnemyEditorPage extends HookWidget {
  const EnemyEditorPage({Key key, this.enemy}) : super(key: key);

  final Enemy enemy;

  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController(
      text: enemy?.name,
    );
    final currentHealthController = useTextEditingController(
      text: (enemy?.currentHealth ?? 0).toString(),
    );
    final maxHealthController = useTextEditingController(
      text: (enemy?.maxHealth ?? 0).toString(),
    );
    final armorController = useTextEditingController(
      text: (enemy?.armor ?? 0).toString(),
    );
    final enemyImage = useImagePicker();
    final isSendingData = useState(false);

    final updateEnemy = () {
      final controller = Get.find<EnemyController>();
      final enemy = EnemyData(
        id: this.enemy?.id,
        name: nameController.text,
        image: enemyImage.image,
        currentHealth: double.parse(currentHealthController.text),
        maxHealth: double.parse(maxHealthController.text),
        armor: double.parse(armorController.text),
      );

      isSendingData.value = true;

      final updateOperation = controller.updateEnemy(
        enemy,
        existingEnemy: this.enemy,
      );

      updateOperation.then((_) {
        isSendingData.value = false;
        Get.back();
      }).catchError((_) => isSendingData.value = false);
    };

    final action = '${enemy == null ? 'Создать' : 'Отредактировать'}';

    return Scaffold(
      appBar: AppBar(
        title: Text('$action врага'),
      ),
      body: DropFocus(
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            _InputField(
              title: 'Название',
              controller: nameController,
            ),
            const SizedBox(height: 16),
            _InputField(
              title: 'Текущее здоровье',
              controller: currentHealthController,
              onlyDigits: true,
            ),
            const SizedBox(height: 16),
            _InputField(
              title: 'Макс. здоровье',
              controller: maxHealthController,
              onlyDigits: true,
            ),
            const SizedBox(height: 16),
            _InputField(
              title: 'Броня',
              controller: armorController,
              onlyDigits: true,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: Color(0xfffcfcfc),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(width: 1, color: Colors.grey.withAlpha(80)),
              ),
              height: 200,
              width: 320,
              child: enemyImage.image == null
                  ? enemy?.imageUrl != null
                      ? Image.network(enemy.imageUrl)
                      : Container()
                  : Image.memory(enemyImage.image),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: enemyImage.pickImage,
              child: Text('Выбрать изображение врага'),
            ),
            const SizedBox(height: 24),
            const Divider(height: 32),
            ElevatedButton(
              onPressed: isSendingData.value ? null : updateEnemy,
              child: SizedBox(
                height: 40,
                width: 180,
                child: Center(
                  child: isSendingData.value
                      ? SizedBox(
                          height: 28,
                          width: 28,
                          child: CircularProgressIndicator(),
                        )
                      : Text('$action врага'),
                ),
              ),
            ),
          ],
        ),
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
