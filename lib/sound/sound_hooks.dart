import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

_AudioPlayer useAudioPlayer() {
  final audioPlayer = useState(AudioPlayer(mode: PlayerMode.LOW_LATENCY));
  final playerState = useState(audioPlayer.value.state);

  useEffect(() {
    audioPlayer.value.release();

    final subscription = audioPlayer.value.onPlayerStateChanged.listen((state) {
      playerState.value = state;
    });

    return () {
      subscription.cancel();
      audioPlayer.dispose();
    };
  }, []);

  return _AudioPlayer(
    player: audioPlayer.value,
    state: playerState.value,
  );
}

class _AudioPlayer {
  _AudioPlayer({
    @required this.state,
    @required this.player,
  });

  final AudioPlayerState state;
  final AudioPlayer player;
}
