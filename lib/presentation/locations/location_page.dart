import 'package:dnd/models/locations/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LocationPage extends HookWidget {
  const LocationPage({Key key, @required this.location}) : super(key: key);
  final Location location;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      final player = AudioPlayer();

      final initializePlayer = () async {
        await player.setUrl(location.trackUrl);
        await player.setLoopMode(LoopMode.one);

        await player.setVolume(0.1);
        await player.play();

        for (int i = 1; i <= 5; i++) {
          await player.setVolume(0.0 * i);
          await Future.delayed(const Duration(seconds: 5));
        }
      };

      initializePlayer();

      return () async {
        await player.stop();
        await player.dispose();
      };
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildLocationTitle(),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Image.network(location.imageUrl),
      ),
    );
  }

  Widget _buildLocationTitle() {
    return Positioned(
      bottom: 24,
      left: 32,
      child: GestureDetector(
        onDoubleTap: () => Get.back(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(30),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            location.name,
            style: TextStyle(
              fontSize: 50,
              color: Colors.white.withAlpha(200),
            ),
          ),
        ),
      ),
    );
  }
}
