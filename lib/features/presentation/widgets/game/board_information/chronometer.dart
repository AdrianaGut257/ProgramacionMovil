import 'dart:async';
import 'package:flutter/material.dart';
import 'package:programacion_movil/features/presentation/utils/sound_manager.dart';

class ChronometerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeEnd;
  final bool showAddButton;
  final VoidCallback? onAddTime;
  final bool isActive;

  const ChronometerWidget({
    super.key,
    required this.duration,
    required this.onTimeEnd,
    this.showAddButton = false,
    this.onAddTime,
    this.isActive = true,
  });

  @override
  State<ChronometerWidget> createState() => ChronometerWidgetState();
}

class ChronometerWidgetState extends State<ChronometerWidget> {
  late int seconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    seconds = widget.duration.inSeconds;
    if (widget.isActive) _startTimer();
  }

  @override
  void didUpdateWidget(ChronometerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.duration != widget.duration) {
      setState(() => seconds = widget.duration.inSeconds);
    }

    if (!oldWidget.isActive && widget.isActive) {
      _startTimer();
    }

    if (oldWidget.isActive && !widget.isActive) {
      timer?.cancel();
    }
  }

  void _startTimer() {
    if (!widget.isActive) return;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (seconds > 0) {
        await SoundManager.playTick();
        setState(() => seconds--);
      } else {
        t.cancel();
        if (widget.isActive) widget.onTimeEnd();
      }
    });
  }

  void _increaseSeconds(int value) {
    setState(() => seconds += value);
  }

  void _addTime() {
    _increaseSeconds(5);
    widget.onAddTime?.call();
  }

  void addExtraTime(int extraSeconds) => _increaseSeconds(extraSeconds);

  void reset({required Duration newDuration, bool start = true}) {
    timer?.cancel();
    setState(() => seconds = newDuration.inSeconds);
    if (start) _startTimer();
  }

  void pause() {
    timer?.cancel();
    SoundManager.stopTimer();
  }

  void resume() {
    if (widget.isActive) _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 202, 202, 202),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, color: Colors.black),
          const SizedBox(width: 8),
          Text(
            "00:${seconds.toString().padLeft(2, '0')}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (widget.showAddButton) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _addTime,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
