enum MediaType { image, gif, video }

class ScreenSaverMedia {
  final MediaType type;
  final String source;
  final String? placeholder;

  const ScreenSaverMedia(this.type, this.source, {this.placeholder});

  const ScreenSaverMedia.image(this.source, {this.placeholder})
    : type = MediaType.image;

  const ScreenSaverMedia.gif(this.source, {this.placeholder})
    : type = MediaType.gif;

  const ScreenSaverMedia.video(this.source, {this.placeholder})
    : type = MediaType.video;
}
