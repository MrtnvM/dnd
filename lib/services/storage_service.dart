import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class StorageService extends GetxService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadAudio(String name, Uint8List file) {
    return uploadFile('audio/$name', file);
  }

  Future<String> uploadImage(String name, Uint8List file) {
    return uploadFile('images/$name', file);
  }

  Future<String> uploadFile(String path, Uint8List file) async {
    final ref = _storage.ref(path);

    try {
      final uploadTask = ref.putData(file);
      uploadTask.snapshotEvents.listen((e) {
        final progress = e.bytesTransferred / e.totalBytes;
        print('PROGRESS: ${(progress * 100).toStringAsFixed(2)}');
      });

      await uploadTask;

      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e);
      throw e;
    }
  }
}
