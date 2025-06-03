/// Defines the type of media to be displayed.
enum MediaType {
  /// A static image.
  image,

  /// An animated GIF.
  gif,

  /// A video file.
  video,
}

/// A model class representing a media item for use in the screen saver.
///
/// It contains information about the type of media, its source path or URL,
/// and an optional placeholder image to display if loading fails.
class ScreenSaverMedia {
  /// The type of media (image, gif, or video).
  final MediaType type;

  /// The source path or URL of the media.
  final String source;

  /// An optional placeholder image asset path to use if the media fails to load.
  final String? placeholder;

  /// Creates a [ScreenSaverMedia] with the given [type], [source], and optional [placeholder].
  const ScreenSaverMedia(this.type, this.source, {this.placeholder});

  /// Creates an image media item with the given [source] and optional [placeholder].
  const ScreenSaverMedia.image(this.source, {this.placeholder})
    : type = MediaType.image;

  /// Creates a gif media item with the given [source] and optional [placeholder].
  const ScreenSaverMedia.gif(this.source, {this.placeholder})
    : type = MediaType.gif;

  /// Creates a video media item with the given [source] and optional [placeholder].
  const ScreenSaverMedia.video(this.source, {this.placeholder})
    : type = MediaType.video;
}
