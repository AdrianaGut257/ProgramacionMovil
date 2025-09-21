import 'dart:async';
import 'package:flutter/material.dart';

class ChronometerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeEnd;

  const ChronometerWidget({
    super.key,
    required this.duration,
    required this.onTimeEnd,
  });

  @override
  State<ChronometerWidget> createState() => _ChronometerWidgetState();
}

class _ChronometerWidgetState extends State<ChronometerWidget> {
  late int seconds;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    seconds = widget.duration.inSeconds;
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds > 0) {
        setState(() => seconds--);
      } else {
        t.cancel();
        widget.onTimeEnd();
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.timer, color: Colors.black),
        const SizedBox(width: 8),
        Text(
          "00:${seconds.toString().padLeft(2, '0')}",
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
