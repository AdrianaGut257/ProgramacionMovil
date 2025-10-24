import 'package:just_audio/just_audio.dart';

class SoundManager {
  // Pool de 3 reproductores para efectos (permite clics rápidos sin interrumpirse)
  static final List<AudioPlayer> _sfxPool = [];
  static int _currentIndex = 0;
  static const int _poolSize = 3;

  // Reproductor dedicado para el timer (con bucle)
  static AudioPlayer? _timerPlayer;
  static bool _isTimerPlaying = false;

  /// Inicializar el sistema de sonido (llamar al inicio de la app)
  static Future<void> init() async {
    //print('🔧 Inicializando sonidos...');
    
    // Crear 3 reproductores para efectos
    for (int i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      await player.setVolume(1.0);
      _sfxPool.add(player);
    }

    // Crear reproductor dedicado para el timer
    _timerPlayer = AudioPlayer();
    await _timerPlayer!.setVolume(1.0);
    await _timerPlayer!.setLoopMode(LoopMode.one); // Activar bucle infinito
    
    //print('✅ Sonidos listos');
  }

  /// Obtener el siguiente reproductor disponible (rotación circular)
  static AudioPlayer _getNextPlayer() {
    final player = _sfxPool[_currentIndex];
    _currentIndex = (_currentIndex + 1) % _poolSize;
    return player;
  }

  /// Reproducir sonido de click/botón
  static Future<void> playClick() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/button2.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //print('❌ Error al reproducir click: $e');
    }
  }

  /// Reproducir sonido de éxito
  static Future<void> playSuccess() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/aceptado.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //print('❌ Error al reproducir success: $e');
    }
  }

  /// Reproducir sonido de error
  static Future<void> playError() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/rechazado1.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //print('❌ Error al reproducir error: $e');
    }
  }

  /// ⏰ INICIAR el sonido del timer en bucle
  static Future<void> playStartRound() async {
    try {
      if (_timerPlayer == null) return;
      
      // Si ya está sonando, no hacer nada
      if (_isTimerPlaying) return;

      await _timerPlayer!.setAsset('assets/sounds/timer10Sec.mp3');
      await _timerPlayer!.seek(Duration.zero);
      await _timerPlayer!.play();
      _isTimerPlaying = true;
      
      //print('⏰ Timer iniciado');
    } catch (e) {
      //print('❌ Error al reproducir timer: $e');
    }
  }

  /// ⏸️ DETENER el sonido del timer
  static Future<void> stopTimer() async {
    try {
      if (_timerPlayer == null) return;
      
      await _timerPlayer!.pause();
      await _timerPlayer!.seek(Duration.zero); // Reiniciar posición
      _isTimerPlaying = false;
      
      //print('⏸️ Timer detenido');
    } catch (e) {
      //print('❌ Error al detener timer: $e');
    }
  }

  /// Reproducir sonido de ganadores
  static Future<void> playWinners() async {
    try {
      final player = _getNextPlayer();
      await player.setAsset('assets/sounds/winner-game.mp3');
      await player.seek(Duration.zero);
      player.play();
    } catch (e) {
      //print('❌ Error al reproducir winners: $e');
    }
  }

  /// Limpiar recursos (llamar cuando cierres la app)
  static Future<void> dispose() async {
    for (var player in _sfxPool) {
      await player.dispose();
    }
    
    if (_timerPlayer != null) {
      await _timerPlayer!.dispose();
      _timerPlayer = null;
    }
  }
}