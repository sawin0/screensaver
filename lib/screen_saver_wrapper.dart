import 'dart:async';

import 'package:flutter/material.dart';

import 'screen_saver.dart';
import 'screen_saver_media.dart';

class ScreenSaverWrapper extends StatefulWidget {
  final Widget child;
  final List<ScreenSaverMedia> mediaItems;
  final Duration inactivityDuration;
  final Duration slideDuration;
  final Curve slideCurve;
  final Color backgroundColor;

  const ScreenSaverWrapper({
    super.key,
    required this.child,
    required this.mediaItems,
    this.inactivityDuration = const Duration(minutes: 1),
    this.slideDuration = const Duration(seconds: 5),
    this.slideCurve = Curves.easeInOut,
    this.backgroundColor = Colors.black,
  });

  @override
  State<ScreenSaverWrapper> createState() => _ScreenSaverWrapperState();
}

class _ScreenSaverWrapperState extends State<ScreenSaverWrapper> {
  Timer? _inactivityTimer;
  bool _screenSaverActive = false;

  @override
  void initState() {
    super.initState();
    _resetTimer();
  }

  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration, () {
      if (!_screenSaverActive) {
        setState(() => _screenSaverActive = true);
      }
    });
  }

  void _handleUserInteraction([_]) {
    if (_screenSaverActive) {
      setState(() => _screenSaverActive = false);
    }
    _resetTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handleUserInteraction,
      child: Stack(
        children: [
          widget.child,
          if (_screenSaverActive)
            ScreenSaver(
              mediaItems: widget.mediaItems,
              slideDuration: widget.slideDuration,
              slideCurve: widget.slideCurve,
              backgroundColor: widget.backgroundColor,
              onTap: _handleUserInteraction,
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }
}
