import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:gallery_saver/gallery_saver.dart';
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
  String _titleMessage = Config.defaultAppBarTitle;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
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
      appBar: AppBar(title: Text(_titleMessage)),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Center(
        child: FutureBuilder<void>(
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
            for (var i = 0; i < Config.sleepTime; i++) {
              setState(() {
                _titleMessage =
                    "${Config.message_recording} ${Config.sleepTime - i}";
              });
              await Future.delayed(const Duration(seconds: 1));
            }
            final video = await _controller.stopVideoRecording();
            setState(() {
              _titleMessage = Config.message_stopped;
            });
            await GallerySaver.saveVideo(video.path);
            setState(() {
              _titleMessage = Config.message_saved;
            });
            File(video.path).deleteSync();
            await Future.delayed(const Duration(seconds: 1));
            setState(() {
              _titleMessage = Config.defaultAppBarTitle;
            });

            if (!mounted) return;
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.videocam_rounded),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_arrow_rounded,
              color: Colors.blue,
            ),
            label: "Player",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt_rounded,
              color: Colors.blue,
            ),
            label: "Camera",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_rounded,
              color: Colors.blue,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
