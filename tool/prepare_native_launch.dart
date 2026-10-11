import 'dart:io';
import 'package:image/image.dart' as image;

void main() {
  const root = 'android/app/src/main/res';
  final logo = image.decodePng(
      File('assets/images/logo_alwadi_transparent_white.png')
          .readAsBytesSync())!;
  for (final entry in {
    'mdpi': 1.0,
    'hdpi': 1.5,
    'xhdpi': 2.0,
    'xxhdpi': 3.0,
    'xxxhdpi': 4.0
  }.entries) {
    final directory = Directory('$root/drawable-${entry.key}')
      ..createSync(recursive: true);
    final resized = image.copyResize(logo, height: (180 * entry.value).round());
    File('${directory.path}/launch_logo.png')
        .writeAsBytesSync(image.encodePng(resized));
  }
  void write(String path, String content) {
    final file = File('$root/$path');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  const background = '''<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
  <item><shape android:shape="rectangle"><solid android:color="#741018" /></shape></item>
  <item android:gravity="center"><bitmap android:gravity="center" android:src="@drawable/launch_logo" /></item>
</layer-list>
''';
  for (final directory in ['drawable', 'drawable-v21']) {
    write('$directory/launch_background.xml', background);
  }
  for (final directory in [
    'values',
    'values-night',
    'values-v31',
    'values-night-v31'
  ]) {
    final modern = directory.endsWith('v31');
    write('$directory/styles.xml', '''<?xml version="1.0" encoding="utf-8"?>
<resources>
  <style name="LaunchTheme" parent="@android:style/Theme.Light.NoTitleBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
    <item name="android:statusBarColor">#741018</item>
    <item name="android:windowLightStatusBar">false</item>
    ${modern ? '<item name="android:windowSplashScreenBackground">#741018</item><item name="android:windowSplashScreenAnimatedIcon">@drawable/launch_logo</item><item name="android:windowSplashScreenIconBackgroundColor">#741018</item>' : ''}
  </style>
  <style name="NormalTheme" parent="@android:style/Theme.Light.NoTitleBar">
    <item name="android:windowBackground">#FFFFFF</item>
    <item name="android:statusBarColor">#FFFFFF</item>
    <item name="android:windowLightStatusBar">true</item>
  </style>
</resources>
''');
  }
}
