import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/presentation/locations/edit_location_page.dart';
import 'package:dnd/presentation/locations/location_page.dart';
import 'package:dnd/widgets/containers/grid_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewLocationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      initState: (_) => LocationController.to.getLocations(),
      builder: (controller) => GridEditor<Location>(
        title: 'Локации',
        items: controller.locations,
        loadItems: () => controller.getLocations(),
        deleteItem: (id) => controller.deleteLocation(id),
        controllerStatus: controller.status,
        goToItemEditor: (l) => Get.to(() => EditLocationPage(location: l)),
        goToItem: (l) => Get.to(() => LocationPage(location: l)),
      ),
    );
  }
}
