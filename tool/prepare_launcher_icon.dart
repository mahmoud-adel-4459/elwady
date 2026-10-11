import 'dart:io';
import 'package:image/image.dart' as image;

// Keep the supplied logo's proportions and give legacy launchers a white canvas.
void main() {
  final source = image.decodePng(
      File('assets/images/logo_alwadi_burgundy.png').readAsBytesSync())!;
  final canvas = image.Image(width: 1024, height: 1024);
  image.fill(canvas, color: image.ColorRgb8(255, 255, 255));
  final logo = image.copyResize(source, height: 820);
  image.compositeImage(canvas, logo,
      dstX: (1024 - logo.width) ~/ 2, dstY: (1024 - logo.height) ~/ 2);
  File('assets/images/launcher_icon.png')
      .writeAsBytesSync(image.encodePng(canvas));
}
