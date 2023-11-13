import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(
      const MaterialApp(
        // theme: ThemeData(useMaterial3: true),
        home: WebViewApp(),
      ),
    );
  });
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  AudioPlayer audioPlayer = AudioPlayer();
  AudioCache audioCache = AudioCache();

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('http://68.183.154.194:8080/'),
      )
      ..setNavigationDelegate(NavigationDelegate(
          onPageStarted: (url) => {

                if (url.contains('categories') || url.contains('login'))
                  {
                    audioPlayer.play(AssetSource('music/casino.mp3')),
                    audioPlayer.setReleaseMode(ReleaseMode.loop)
                    }
                else
                  {audioPlayer.stop()}
              }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WillPopScope(
      child: WebViewWidget(
        controller: controller,
      ),
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
        } else {
          return true;
        }
      },
    ));
  }

  void playBackgroundMusic() async {
    await audioPlayer.play(UrlSource(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
  }
}
