import 'dart:async';

import 'package:flutter/material.dart';

import 'screen_saver.dart';
import 'screen_saver_media.dart';

/// A widget that wraps around a child and shows a screen saver
/// after a period of user inactivity.
///
/// It listens for user interaction and resets the inactivity timer.
/// If the user is inactive for [inactivityDuration], it activates a screen saver.
class ScreenSaverWrapper extends StatefulWidget {
  /// The main content of the app over which the screen saver will appear.
  final Widget child;

  /// A list of media items to display in the screen saver.
  final List<ScreenSaverMedia> mediaItems;

  /// The duration of inactivity after which the screen saver activates.
  final Duration inactivityDuration;

  /// Duration between slide transitions in the screen saver.
  final Duration slideDuration;

  /// The animation curve for slide transitions.
  final Curve slideCurve;

  /// The background color of the screen saver.
  final Color backgroundColor;

  /// Creates a [ScreenSaverWrapper] widget.
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

  /// Resets the inactivity timer and starts it again.
  void _resetTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(widget.inactivityDuration, () {
      if (!_screenSaverActive) {
        setState(() => _screenSaverActive = true);
      }
    });
  }

  /// Handles user interaction and resets the screen saver state.
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
