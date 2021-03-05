class Location {
  final String name;
  final String imageUrl;
  final String trackUrl;

  Location({
    this.name,
    this.imageUrl,
    this.trackUrl,
  });

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      imageUrl: json['imageUrl'],
      trackUrl: json['trackUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'trackUrl': trackUrl,
    };
  }
}
