import 'package:dnd/controllers/game_controller.dart';
import 'package:dnd/presentation/home/admin_page.dart';
import 'package:dnd/presentation/home/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class HomePage extends HookWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбери режим'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildButton(
              'Перейти в админку',
              () {
                GameController.to.isGame = false;
                Get.to(() => AdminPage());
              },
            ),
            _buildButton(
              'Перейти к игре',
              () {
                GameController.to.isGame = true;
                Get.to(() => GamePage());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onPress) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPress,
        child: SizedBox(
          height: 40,
          width: 200,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
