import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;
  bool play = false;

  @override
  void initState() {
    super.initState();
    //    _controller = VideoPlayerController.networkUrl(Uri.parse(
    //         'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
    _controller = VideoPlayerController.asset(
      'assets/videos/bee.mp4',
    )..initialize().then((_) {
        setState(() {
          _controller.addListener(() {
            if (_controller.value.position == _controller.value.duration) {
              setState(() {
                _controller.seekTo(Duration(seconds: 0));
              });
            }
          });
        });
      });
  }

  String videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final hours = twoDigits(duration.inHours);

    final minutes = twoDigits(duration.inMinutes.remainder(60));

    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter'),
        centerTitle: true,
      ),
      body: Center(
          child: _controller.value.isInitialized
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 400,
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller)),
                            // Padding(padding: EdgeInsets.all(10)),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Padding(padding: EdgeInsets.all(10)),
                            //     ElevatedButton(
                            //         style: ButtonStyle(
                            //           backgroundColor:
                            //               MaterialStateProperty.all<Color>(
                            //                   _controller.value.isPlaying
                            //                       ? Colors.white
                            //                       : Colors.amber),
                            //         ),
                            //         onPressed: () {
                            //           setState(() {
                            //             if (_controller.value.isPlaying) {
                            //               _controller.pause();
                            //             } else {
                            //               _controller.play();
                            //             }
                            //           });
                            //         },
                            //         child: Icon(_controller.value.isPlaying &&
                            //                 _controller.value.isCompleted ==
                            //                     false
                            //             ? Icons.pause
                            //             : Icons.play_arrow)),
                            //     Padding(padding: EdgeInsets.all(10)),
                            //     ElevatedButton(
                            //         onPressed: () {
                            //           _controller.seekTo(Duration(
                            //               seconds: _controller
                            //                       .value.position.inSeconds +
                            //                   1));
                            //         },
                            //         child: Icon(Icons.fast_forward_outlined)),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                      Row( crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _controller,
                            builder: (context, value, child) {
                              return Text(
                                videoDuration(value.position),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              );
                            },
                          ),
                          SizedBox(
                            height: 10,
                            width: 250,
                            child: VideoProgressIndicator(_controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12)),
                          ),
                          Text(
                            videoDuration(_controller.value.duration),
                            style: TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.all(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.all(10)),
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    _controller.value.isPlaying
                                        ? Colors.white
                                        : Colors.amber),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                });
                              },
                              child: Icon(_controller.value.isPlaying &&
                                  _controller.value.isCompleted == false
                                  ? Icons.pause
                                  : Icons.play_arrow)),
                          Padding(padding: EdgeInsets.all(10)),
                          ElevatedButton(
                              onPressed: () {
                                _controller.seekTo(Duration(
                                    seconds:
                                    _controller.value.position.inSeconds +
                                        1));
                              },
                              child: Icon(Icons.fast_forward_outlined)),
                        ],
                      )
                    ],
                  ),
                )
              : Container()),
    );
  }
}
