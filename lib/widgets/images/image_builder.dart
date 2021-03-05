import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ImageSource { network, file }

class ImageInfo {
  ImageInfo({
    @required this.path,
    @required this.source,
  });

  final String path;
  final ImageSource source;
}

class ImageBuilder extends StatelessWidget {
  const ImageBuilder({Key key, @required this.image}) : super(key: key);

  final ImageInfo image;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || image.source == ImageSource.network) {
      return Image.network(image.path);
    }

    return Image.file(File(image.path));
  }
}
