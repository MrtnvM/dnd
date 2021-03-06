import 'package:dnd/presentation/enemies/indicator.dart';
import 'package:flutter/material.dart';

class HealthIndicator extends StatelessWidget {
  const HealthIndicator({Key key, @required this.value}) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    const image =
        'https://firebasestorage.googleapis.com/v0/b/dungeon-and-dragons-53283.appspot.com/o/love-1217491_960_720.webp?alt=media&token=6337f68a-6a53-42e3-ac15-ba4e6b1bfe42';

    return Indicator(imageUrl: image, value: value);
  }
}
