// ignore: avoid_web_libraries_in_flutter
import 'dart:html' hide VoidCallback;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

export 'package:file_picker/file_picker.dart';

_FileSelector useFilePicker(FileType type) {
  final fileName = useState('');
  final fileBytes = useState<Uint8List>(null);

  final selectImage = () async {
    final uploadInput = FileUploadInputElement();

    switch (type) {
      case FileType.image:
        uploadInput.accept = 'image/jpeg;image/png';
        break;

      case FileType.audio:
        uploadInput.accept = 'audio/mpeg';
        break;

      default:
        break;
    }

    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;

      if (files.length == 1) {
        final file = files[0];
        final reader = FileReader();

        reader.onLoadEnd.listen((e) {
          fileBytes.value = reader.result;
          fileName.value = file.name;
        });

        reader.onError.listen((fileEvent) {
          print(fileEvent);
        });

        reader.readAsArrayBuffer(file);
      }
    });
  };

  return _FileSelector(
    fileBytes: fileBytes.value,
    pickFile: selectImage,
    fileName: fileName.value,
  );
}

class _FileSelector {
  _FileSelector({
    this.fileBytes,
    this.pickFile,
    this.fileName,
  });

  final Uint8List fileBytes;
  final String fileName;
  final VoidCallback pickFile;
}
