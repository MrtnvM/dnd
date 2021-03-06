import 'package:flutter/material.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key key,
    @required this.imageUrl,
    @required this.value,
  }) : super(key: key);

  final String imageUrl;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              height: 64,
              width: 64,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Text(
                '$value',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white.withAlpha(200),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
