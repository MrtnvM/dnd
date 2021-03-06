import 'package:dnd/presentation/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DndApp extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dungeon and Dragons',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.forumTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      defaultTransition: Transition.fadeIn,
      home: const HomePage(),
    );
  }
}
