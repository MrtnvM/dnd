import 'dart:typed_data';

import 'package:dnd/hooks/file_hooks.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class _ImagePicker {
  _ImagePicker({
    this.image,
    this.pickImage,
  });

  final Uint8List image;
  final VoidCallback pickImage;
}

_ImagePicker useImagePicker() {
  final fileSelector = useFilePicker(FileType.image);

  return _ImagePicker(
    image: fileSelector.fileBytes,
    pickImage: fileSelector.pickFile,
  );
}
