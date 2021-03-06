import 'package:dnd/presentation/enemies/enemies_page.dart';
import 'package:dnd/presentation/locations/locations_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const locationsIndex = 0;
const enemiesIndex = 1;

class DndApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final currentTabIndex = useState(locationsIndex);

    final buildEditor = {
          locationsIndex: () => LocationsPage(),
          enemiesIndex: () => EnemiesPage(),
        }[currentTabIndex.value] ??
        () => Container();

    return GetMaterialApp(
      title: 'Dungeon and Dragons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.forumTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      defaultTransition: Transition.fadeIn,
      home: Scaffold(
        body: buildEditor(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIndex.value,
          onTap: (i) => currentTabIndex.value = i,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.place),
              label: 'Локации',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dangerous),
              label: 'Враги',
            ),
          ],
        ),
      ),
    );
  }
}
