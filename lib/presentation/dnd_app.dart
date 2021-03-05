import 'package:dnd/presentation/locations/locations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

class DndApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dungeon and Dragons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      defaultTransition: Transition.fadeIn,
      home: LocationsPage(),
    );
  }
}
