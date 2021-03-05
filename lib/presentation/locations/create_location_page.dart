import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateLocationPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final imageController = useState<DropzoneViewController>(null);

    return Scaffold(
      appBar: AppBar(title: Text('Создать локацию')),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: 'Название'),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 100,
              child: Stack(
                children: [
                  DropzoneView(
                    mime: ['image/jpeg', 'image/png', 'image/jpg'],
                    operation: DragOperation.copy,
                    cursor: CursorType.grab,
                    onCreated: (ctrl) => imageController.value = ctrl,
                    onLoaded: () => print('Zone loaded'),
                    onError: (ev) => print('Error: $ev'),
                    onHover: () => print('Zone hovered'),
                    onDrop: (ev) => print('Drop: $ev'),
                    onLeave: () => print('Zone left'),
                  ),
                  Center(child: Text('Drop files here')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
