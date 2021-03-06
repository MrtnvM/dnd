import 'package:dnd/models/game_object.dart';

class Location extends GameObject {
  final String id;
  final String name;
  final String imageUrl;
  final String trackUrl;

  Location({
    this.id,
    this.name,
    this.imageUrl,
    this.trackUrl,
  });

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      id: json["id"],
      name: json['name'],
      imageUrl: json['imageUrl'],
      trackUrl: json['trackUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'trackUrl': trackUrl,
    };
  }
}
