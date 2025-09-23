import 'dart:async';
import 'package:flutter/material.dart';

class ChronometerWidget extends StatefulWidget {
  final Duration duration;
  final VoidCallback onTimeEnd;
  final bool showAddButton;
  final VoidCallback? onAddTime;

  const ChronometerWidget({
    super.key,
    required this.duration,
    required this.onTimeEnd,
    this.showAddButton = false,
    this.onAddTime,
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

  void _addTime() {
    setState(() {
      seconds += 5;
    });
    if (widget.onAddTime != null) {
      widget.onAddTime!();
    }
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
                decoration: BoxDecoration(
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
