import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

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
      appBar: AppBar(title: const Text('Take a picture')),
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
    // floatingActionButton: FloatingActionButton(
    //   // Provide an onPressed callback.
    //   onPressed: () async {
    //     // Take the Picture in a try / catch block. If anything goes wrong,
    //     // catch the error.
    //     try {
    //       // Ensure that the camera is initialized.
    //       await _initializeControllerFuture;

    //       // Attempt to take a picture and get the file `image`
    //       // where it was saved.
    //       // final image = await _controller.takePicture();
    //       // final path = image.path;
    //       // final bytes = await File(path).readAsBytes();
    //       // final img.Image image = img.decodeImage(bytes);

    //       if (!mounted) return;
    //     } catch (e) {
    //       // If an error occurs, log the error to the console.
    //       print(e);
    //     }
    //   },
    //   child: const Icon(Icons.camera_alt),
    // ),
  }
}
