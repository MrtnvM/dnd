import 'package:dnd/presentation/enemies/indicator.dart';
import 'package:flutter/material.dart';

class ArmorIndicator extends StatelessWidget {
  const ArmorIndicator({Key key, @required this.value}) : super(key: key);

  final double value;

  @override
  Widget build(BuildContext context) {
    const image =
        'https://firebasestorage.googleapis.com/v0/b/dungeon-and-dragons-53283.appspot.com/o/icons%2Fshield.png?alt=media&token=e9d93210-a0f6-4499-8b64-e158b990ec44';

    return Indicator(imageUrl: image, value: value);
  }
}
