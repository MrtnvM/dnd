import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomePage extends HookWidget {
  const HomePage({@required this.title}) : super();
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: FittedBox(
          fit: BoxFit.cover,
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/dungeon-and-dragons-53283.appspot.com/o/images%2Fevil-magician-2.jpg?alt=media&token=91c6fb73-7d90-4f00-a510-2136f2506610',
          ),
        ),
      ),
    );
  }
}
