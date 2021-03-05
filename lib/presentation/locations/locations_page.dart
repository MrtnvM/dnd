import 'package:dnd/controllers/location_controller.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/presentation/locations/create_location_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      initState: (c) => LocationController.to.getLocations(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: Text('Локации')),
          body: controller.obx(
            (locations) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Scrollbar(
                child: GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 24,
                  childAspectRatio: 1.5,
                  children: [
                    for (final location in locations)
                      LocationItemWidget(location: location),
                  ],
                ),
              ),
            ),
            onLoading: Center(child: CircularProgressIndicator()),
            onEmpty: NoLocationsWidget(),
            onError: (error) => LocationsErrorStateWidget(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Get.to(CreateLocationPage()),
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class LocationsErrorStateWidget extends StatelessWidget {
  const LocationsErrorStateWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Не удалось загрузить локации'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => LocationController.to.getLocations(),
            child: Text('Повторить'),
          ),
        ],
      ),
    );
  }
}

class NoLocationsWidget extends StatelessWidget {
  const NoLocationsWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Нет локаций'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.to(CreateLocationPage()),
            child: Text('Создать'),
          ),
        ],
      ),
    );
  }
}

class LocationItemWidget extends StatelessWidget {
  const LocationItemWidget({
    Key key,
    @required this.location,
  }) : super(key: key);

  final Location location;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffcccccc),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(location.imageUrl),
              ),
            ),
            Container(
              constraints: BoxConstraints.expand(),
              color: Colors.grey.withAlpha(80),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: Text(
                location.name ?? '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
