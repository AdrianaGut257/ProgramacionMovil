import 'package:just_audio/just_audio.dart';

class SoundManager {
  static final List<AudioPlayer> _sfxPool = [];
  static int _currentIndex = 0;
  static const int _poolSize = 3;

  static AudioPlayer? _timerPlayer;
  static bool _isTimerPlaying = false;

  static Future<void> init() async {
    for (int i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      await player.setVolume(1.0);
      _sfxPool.add(player);
    }

    _timerPlayer = AudioPlayer();
    await _timerPlayer!.setVolume(1.0);
    await _timerPlayer!.setLoopMode(LoopMode.one);
  }

  static AudioPlayer _getNextPlayer() {
    final player = _sfxPool[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _poolSize;
    return player;
  }

  static Future<void> playClick() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/button2.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //
    }
  }

  static Future<void> playSuccess() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/aceptado.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //
    }
  }

  static Future<void> playError() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/error1.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //
    }
  }

  static Future<void> playStartRound() async {
    try {
      if (_timerPlayer == null) return;
      if (_isTimerPlaying) return;

      await _timerPlayer!.setAsset('assets/sounds/timer10Sec.mp3');
      await _timerPlayer!.seek(Duration.zero);
      await _timerPlayer!.play();
      _isTimerPlaying = true;
    } catch (e) {
      //
    }
  }

  static Future<void> stopTimer() async {
    try {
      if (_timerPlayer == null) return;

      await _timerPlayer!.pause();
      await _timerPlayer!.seek(Duration.zero);
      _isTimerPlaying = false;
    } catch (e) {
      //
    }
  }

  static Future<void> playWinners() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/winner-game.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //
    }
  }

  static Future<void> dispose() async {
    for (var player in _sfxPool) {
      await player.dispose();
    }

    if (_timerPlayer != null) {
      await _timerPlayer!.dispose();
      _timerPlayer = null;
    }
  }

  static Future<void> playTick() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/tick.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //
    }
  }
}
