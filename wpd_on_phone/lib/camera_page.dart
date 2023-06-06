import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:io';
import 'config.dart';
// A screen that allows users to take a picture using a given camera.

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _notConnectedToServer = false;
  static int _recordTime = Config.recordTime;
  String _titleMessage = "Record $_recordTime seconds of video";
  String _serverLink = Config.serverLink;
  String _connectionMessage = Config.message_notChecked;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text(Config.defaultTitle)),
      body: Column(
        children: [
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(Config.title_server,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Spacer(flex: 1),
              TextButton(
                  onPressed: () {
                    // * Test connection with server
                    var httpClient = http.Client();
                    var request = http.Request('GET', Uri.parse(_serverLink));
                    var response = httpClient.send(request);
                    response.then((value) {
                      if (value.statusCode == 200) {
                        setState(() {
                          _notConnectedToServer = false;
                          _connectionMessage = Config.message_connected;
                        });
                      } else {
                        setState(() {
                          _notConnectedToServer = true;
                          _connectionMessage = Config.message_notConnected;
                        });
                      }
                    });
                  },
                  child: const Text(
                    "Test connection",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Spacer(flex: 8),
              Text(_connectionMessage,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  )),
              Spacer(flex: 1),
            ],
          ),
          SizedBox(
            child: TextField(
              enabled: _notConnectedToServer,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "http://....app",
              ),
              onChanged: (text) async {
                setState(() {
                  _serverLink = text;
                });
              },
              maxLines: 1,
              minLines: 1,
            ),
          ),
          Container(color: Colors.blue, height: 5),
          Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(_titleMessage,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                )),
          ),
          SizedBox(
            child: TextField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Record time (number only)',
              ),
              onChanged: (text) async {
                setState(() {
                  _recordTime = int.parse(text);
                  _titleMessage = "Record $_recordTime seconds of video";
                  print(_recordTime);
                });
              },
              maxLines: 1,
              minLines: 1,
            ),
          ),
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Spacer(flex: 1),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            await _controller.startVideoRecording();
            setState(() {
              _titleMessage = Config.message_recording;
            });
            for (var i = 0; i < _recordTime; i++) {
              setState(() {
                _titleMessage =
                    "${Config.message_recording} ${_recordTime - i}";
              });
              await Future.delayed(const Duration(seconds: 1));
            }
            final _video = await _controller.stopVideoRecording();
            setState(() {
              _titleMessage = Config.message_stopped;
            });

            var url = Uri.parse('${_serverLink}/${basename(_video.path)}');
            var request = http.MultipartRequest('POST', url);

            setState(() {
              _titleMessage = Config.message_loadingVideo;
            });
            // * option 1
            request.files
                .add(await http.MultipartFile.fromPath('file', _video.path));
            // * option 2
            // request.files.add(await http.MultipartFile.fromPath(
            //     'file', File(_video.path).path));
            // * option 3
            // final httpVideo = http.MultipartFile.fromBytes(
            //     basename(_video.path), await File(_video.path).readAsBytes(),
            //     contentType: MediaType('video', 'mp4'),
            //     filename: basename(_video.path));
            // request.files.add(httpVideo);

            setState(() {
              _titleMessage = Config.message_sending;
            });
            var res = await request.send();
            if (res.statusCode == 201) {
              setState(() {
                _titleMessage = Config.message_sent;
              });
            } else {
              setState(() {
                _titleMessage = "Error: ${res.statusCode}";
              });
            }

            var response = await GallerySaver.saveVideo(_video.path,
                albumName: Config.defaultAlbum);
            setState(() {
              _titleMessage = Config.message_saved;
            });

            File(_video.path).deleteSync();
            setState(() {
              _titleMessage = "Record $_recordTime seconds of video";
            });

            if (!mounted) return;
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.videocam_rounded),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.play_arrow_rounded,
      //         color: Colors.blue,
      //       ),
      //       label: "Player",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.camera_alt_rounded,
      //         color: Colors.blue,
      //       ),
      //       label: "Camera",
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(
      //         Icons.settings_rounded,
      //         color: Colors.blue,
      //       ),
      //       label: "Settings",
      //     ),
      //   ],
      // ),
    );
  }
}
