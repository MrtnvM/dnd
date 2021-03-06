import 'package:dnd/controllers/game_controller.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/presentation/locations/location_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class GamePage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final gameController = Get.find<GameController>();
    final currentLocation = useState<Location>(null);
    final locationWidget = useState<Widget>(null);

    return Obx(() {
      final location = gameController.currentLocation.value;

      if (location == null) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (location?.id != currentLocation.value?.id ||
          locationWidget.value == null) {
        locationWidget.value = LocationPage(location: location);
        currentLocation.value = location;
      }

      return AnimatedSwitcher(
        duration: Duration(seconds: 2),
        transitionBuilder: (child, animation) {
          return FadeTransition(child: child, opacity: animation);
        },
        child: locationWidget.value,
      );
    });
  }
}
