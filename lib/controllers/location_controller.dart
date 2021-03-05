import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/models/locations/location_data.dart';
import 'package:dnd/services/storage_service.dart';
import 'package:get/get.dart';

class LocationController extends GetxController
    with StateMixin<List<Location>> {
  final _firestore = FirebaseFirestore.instance;
  var locations = <Location>[];

  static LocationController get to => Get.find();

  Future<void> updateLocation(
    LocationData location, {
    String existingImageUrl,
    String existingTrackUrl,
  }) async {
    final storage = Get.find<StorageService>();

    final trackUrl = location.track != null
        ? await storage.uploadAudio(location.name, location.track)
        : existingTrackUrl;

    if (trackUrl == null) {
      Get.snackbar('Эй, бро!', 'Выбери трек сначала');
      return;
    }

    final imageUrl = location.image != null
        ? await storage.uploadImage(location.name, location.image)
        : existingImageUrl;

    if (imageUrl == null) {
      Get.snackbar('Эй, бро!', 'Выбери изображение локации сначала');
      return;
    }

    final locationModel = Location(
      name: location.name,
      imageUrl: imageUrl,
      trackUrl: trackUrl,
    );

    final docRef = _firestore.collection('locations').doc(location.name);
    final doc = await docRef.get();
    final locationJson = locationModel.toJson();

    if (doc.exists) {
      await docRef.update(locationJson);
    } else {
      await docRef.set(locationJson);
    }

    getLocations();
  }

  Future<List<Location>> getLocations() async {
    change(locations, status: RxStatus.loading());

    try {
      final snapshots = await _firestore.collection('locations').get();
      locations = snapshots.docs //
          .map((s) => s.data())
          .map((l) => Location.fromJson(l))
          .toList();

      change(locations, status: RxStatus.success());
    } catch (error) {
      print(error);
      change(locations, status: RxStatus.error());
    }

    return locations;
  }
}
