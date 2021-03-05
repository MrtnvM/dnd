import 'dart:typed_data';

import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/hooks/file_hooks.dart';
import 'package:dnd/hooks/image_hooks.dart';
import 'package:dnd/models/locations/location_data.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class CreateLocationPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final locationImage = useImagePicker();
    final trackSelector = useFilePicker(FileType.audio);
    final isSendingData = useState(false);

    return Scaffold(
      appBar: AppBar(title: Text('Создать локацию')),
      body: Container(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 60,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Название'),
              ),
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
              child: locationImage.image == null
                  ? Container()
                  : Image.memory(locationImage.image),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: locationImage.pickImage,
              child: Text('Выбрать изображение локации'),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                ElevatedButton(
                  onPressed: trackSelector.pickFile,
                  child: Text('Выбрать трек для локации'),
                ),
                const SizedBox(width: 16),
                Text(trackSelector.fileName ?? ''),
              ],
            ),
            const Divider(height: 32),
            ElevatedButton(
              onPressed: isSendingData.value
                  ? null
                  : () {
                      final controller = Get.find<LocationController>();
                      final location = LocationData(
                        name: nameController.text,
                        image: locationImage.image,
                        track: trackSelector.fileBytes,
                      );

                      isSendingData.value = true;
                      controller
                          .updateLocation(location)
                          .then((_) => isSendingData.value = false)
                          .catchError((_) => isSendingData.value = false);
                    },
              child: SizedBox(
                height: 40,
                width: 180,
                child: Center(
                  child: isSendingData.value
                      ? CircularProgressIndicator()
                      : Text('Создать локацию'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> uploadData(Uint8List data, String path) async {
    final ref = FirebaseStorage.instance.ref(path);

    try {
      final uploadTask = ref.putData(data);
      uploadTask.snapshotEvents.listen((e) {
        final progress = e.bytesTransferred / e.totalBytes;
        print('PROGRESS: ${(progress * 100).toStringAsFixed(2)}');
      });

      await uploadTask;
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
