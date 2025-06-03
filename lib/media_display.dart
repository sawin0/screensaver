import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'screen_saver_media.dart';

class MediaDisplay extends StatefulWidget {
  final ScreenSaverMedia media;

  const MediaDisplay({super.key, required this.media});

  @override
  State<MediaDisplay> createState() => _MediaDisplayState();
}

class _MediaDisplayState extends State<MediaDisplay> {
  VideoPlayerController? _videoController;
  bool _isInitializing = false;

  @override
  void initState() {
    super.initState();
    if (widget.media.type == MediaType.video) {
      _initializeVideo();
    }
  }

  void _initializeVideo() async {
    try {
      setState(() => _isInitializing = true);
      _videoController = widget.media.source.startsWith('http')
          ? VideoPlayerController.networkUrl(Uri.parse(widget.media.source))
          : VideoPlayerController.asset(widget.media.source);

      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play();
    } catch (e) {
      debugPrint('Failed to initialize video: $e');
    } finally {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.media.type) {
      case MediaType.image:
        return _buildImage();
      case MediaType.gif:
        return _buildGif();
      case MediaType.video:
        return _buildVideo();
    }
  }

  Widget _buildImage() {
    return widget.media.source.startsWith('http')
        ? Image.network(
            widget.media.source,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          )
        : Image.asset(
            widget.media.source,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholder(),
          );
  }

  Widget _buildGif() {
    return Image.asset(
      widget.media.source,
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: frame != null ? child : _buildPlaceholder(),
        );
      },
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  Widget _buildVideo() {
    if (_isInitializing || _videoController == null) {
      return _buildPlaceholder();
    }

    if (!_videoController!.value.isInitialized) {
      return _buildPlaceholder();
    }

    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: VideoPlayer(_videoController!),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: widget.media.placeholder != null
          ? Image.asset(widget.media.placeholder!, fit: BoxFit.cover)
          : const Icon(Icons.broken_image, size: 64, color: Colors.white24),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}
