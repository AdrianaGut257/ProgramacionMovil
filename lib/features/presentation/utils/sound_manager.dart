import 'package:just_audio/just_audio.dart';

class SoundManager {
  // Pool de 3 reproductores para efectos (permite clics rápidos sin interrumpirse)
  static final List<AudioPlayer> _sfxPool = [];
  static int _currentIndex = 0;
  static const int _poolSize = 3;

  /// Inicializar el sistema de sonido (llamar al inicio de la app)
  static Future<void> init() async {
    print('🔧 Inicializando sonidos...');
    
    // Crear 3 reproductores
    for (int i = 0; i < _poolSize; i++) {
      final player = AudioPlayer();
      await player.setVolume(1.0); // Volumen máximo
      _sfxPool.add(player);
    }
    
    print('✅ Sonidos listos');
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
      await player.seek(Duration.zero); // Reiniciar desde el inicio
      player.play();
    } catch (e) {
      print('❌ Error al reproducir click: $e');
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
      print('❌ Error al reproducir success: $e');
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
      print('❌ Error al reproducir error: $e');
    }
  }

  /// Limpiar recursos (llamar cuando cierres la app)
  static Future<void> dispose() async {
    for (var player in _sfxPool) {
      await player.dispose();
    }
  }
}