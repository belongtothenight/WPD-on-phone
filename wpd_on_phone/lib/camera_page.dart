// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:path/path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:archive/archive.dart';
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
  static int _recordTime = Config.recordTime;
  String _titleMessage = "Record $_recordTime seconds of video";

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
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
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
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
            await GallerySaver.saveVideo(_video.path,
                albumName: Config.defaultAlbum);
            setState(() {
              _titleMessage = Config.message_sending;
            });

            var url =
                Uri.parse('${Config.serverLink}/${basename(_video.path)}');
            var request = http.MultipartRequest('POST', url);

            // ! This is the code to send the video to server! Buggy
            request.files
                .add(await http.MultipartFile.fromPath('file', _video.path));
            // final httpVideo = http.MultipartFile.fromBytes(
            //     basename(_video.path), await File(_video.path).readAsBytes(),
            //     contentType: MediaType('video', 'mp4'),
            //     filename: basename(_video.path));
            // request.files.add(httpVideo);

            var res = await request.send();
            if (res.statusCode == 200) {
              setState(() {
                _titleMessage = Config.message_sent;
              });
            } else {
              setState(() {
                _titleMessage = "Error: ${res.statusCode}";
              });
            }

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
