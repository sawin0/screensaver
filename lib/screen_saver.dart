import 'dart:async';

import 'package:flutter/material.dart';

import 'media_display.dart';
import 'screen_saver_media.dart';

class ScreenSaver extends StatefulWidget {
  final List<ScreenSaverMedia> mediaItems;
  final Duration slideDuration;
  final Curve slideCurve;
  final Color backgroundColor;
  final VoidCallback onTap;

  const ScreenSaver({
    super.key,
    required this.mediaItems,
    required this.onTap,
    this.slideDuration = const Duration(seconds: 5),
    this.slideCurve = Curves.easeInOut,
    this.backgroundColor = Colors.black,
  });

  @override
  State<ScreenSaver> createState() => _ScreenSaverState();
}

class _ScreenSaverState extends State<ScreenSaver> {
  late PageController _pageController;
  Timer? _slideTimer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startSlideshow();
  }

  void _startSlideshow() {
    _slideTimer = Timer.periodic(widget.slideDuration, (_) {
      if (_currentIndex < widget.mediaItems.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: widget.slideCurve,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Scaffold(
        backgroundColor: widget.backgroundColor,
        body: PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.mediaItems.length,
          itemBuilder: (context, index) {
            return MediaDisplay(media: widget.mediaItems[index]);
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _slideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}
