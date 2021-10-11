import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Player')),
      body: VideoPlayerWidget(),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  final String videoLink =
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4';

  GlobalKey _betterPlayerKey = GlobalKey();

  late BetterPlayerController _betterPlayerController;

  double aspect = 16 / 9;

  @override
  void initState() {
    super.initState();

    final videoModalColor = Colors.white;
    final fontIconColor = Colors.black;

    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: aspect,
      fit: BoxFit.contain,
      autoDetectFullscreenDeviceOrientation: true,
      autoPlay: false,
      placeholderOnTop: true,
      controlsConfiguration: BetterPlayerControlsConfiguration(
          iconsColor: Color(0xffbcbcbc),
          overflowModalColor: videoModalColor,
          overflowMenuIconsColor: fontIconColor,
          overflowModalTextColor: fontIconColor,
          enablePip: true,
          pipMenuIcon: Icons.picture_in_picture_alt),
    );

    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      '$videoLink',
    );

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    _betterPlayerController
        .setupDataSource(dataSource)
        .onError((error, stackTrace) => null);

    _betterPlayerController.isPictureInPictureSupported();
    _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);

    _betterPlayerController.addEventsListener((BetterPlayerEvent event) async {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        //play next video url
      }

      if (_betterPlayerController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: AspectRatio(
            aspectRatio: aspect,
            child: BetterPlayer(
                key: _betterPlayerKey, controller: _betterPlayerController),
          ),
        ),
        ElevatedButton(
          child: Text("Show PiP"),
          onPressed: () {
            _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();

    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
