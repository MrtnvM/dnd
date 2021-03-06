import 'package:dnd/controllers/game_controller.dart';
import 'package:dnd/models/locations/location.dart';
import 'package:dnd/presentation/enemies/enemy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class LocationPage extends HookWidget {
  const LocationPage({Key key, @required this.location}) : super(key: key);
  final Location location;

  @override
  Widget build(BuildContext context) {
    final imageAnimationController = useAnimationController(
      duration: const Duration(seconds: 20),
      lowerBound: 1.0,
      upperBound: 1.15,
    );

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

    useEffect(() {
      const duration = const Duration(seconds: 15);
      const curve = Curves.easeInOutCubic;
      final controller = imageAnimationController;
      var isPlaying = true;

      VoidCallback playAnimation;
      playAnimation = () async {
        await controller.animateTo(1.05, curve: curve, duration: duration);

        if (!isPlaying) return;
        await controller.animateTo(1.0, curve: curve, duration: duration);

        if (isPlaying) playAnimation();
      };

      playAnimation();
      return imageAnimationController.dispose;
    }, []);

    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(imageAnimationController),
          _buildLocationTitle(),
          _buildEnemy(context),
        ],
      ),
    );
  }

  Widget _buildBackground(AnimationController controller) {
    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.cover,
        child: ScaleTransition(
          scale: controller,
          child: Image.network(location.imageUrl),
        ),
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

  Widget _buildEnemy(BuildContext context) {
    final gameController = Get.find<GameController>();

    return Center(
      child: Obx(() {
        final enemy = gameController.currentEnemy.value;
        if (enemy == null) {
          return Container();
        }

        return EnemyWidget(enemy: enemy);
      }),
    );
  }
}
