import 'dart:typed_data';

class LocationData {
  LocationData({
    this.name,
    this.image,
    this.track,
  });

  final String name;
  final Uint8List image;
  final Uint8List track;
}
