# Update Log

1. Finished dev environment setup.
2. Ran initial app on android emulator.
3. Finished writing [workflow.md](https://github.com/belongtothenight/WPD-on-phone/blob/main/workflow.md) of the project this repo based on.
4. Built initial app, installed on android device.
5. Implemented [flutter example](https://docs.flutter.dev/cookbook/plugins/picture-using-camera) to gain access to front camera.
6. Resolved issue when importing opencv_4 in flutter.
   1. Navigate to %appdata%\\..\Local\Pub\Cache\hosted\pub.dev\opencv_4-1.0.0
   2. Open vscode in this directory
   3. Search for "1.3.50" for initial specified kotlin version.
   4. Change it to "1.7.10". (currently default for flutter, 20230513)
7. Encounter problem with opencv_4 in flutter doesn't support cascade classifier.
   1. opencv on dart is a lot less powerful than expected, only bare minimum function are presented.
   2. use [google_ml_kit](https://pub.dev/packages/google_ml_kit) instead.
8. Encounter problem with no similar library as "numpy" in dart.
   1. Use several different packages like [fftea](https://pub.dev/packages/fftea), [image](https://pub.dev/packages/image)
9. Flutter camera photo taking example is not applicable in our usage.
   1. Follow guide [Capture photos from Camera using Image Stream with Flutter](https://medium.com/@hugand/capture-photos-from-camera-using-image-stream-with-flutter-e9af94bc2bee).
   2. Use [camera_camera](https://pub.dev/packages/camera_camera) to replace [camera](https://pub.dev/packages/camera) in order to capture image stream.
   3. With the new package, image will no longer be stored in drive first but memory.
   4. Use [ffi](https://pub.dev/packages/ffi) to gain access of low level control, like image or audio processing.
10. Change methodology to offline processing.
    1. Abandon following packages, "google_ml_kit", "camera_camera", "ffi", "opencv_4".
    2. Remove following files, "processors_noopenmdao.dart".
11. Able to record and save video now.
12. Tested server on local machine.
    1. Unable to connect to it from another machine within the same network.
    2. Focus on file processing first.
13. Able to obtain pulse from video file.
14. Able to obtain BPM record from video file. It will be written in column 3.
    1. Remove original version of data, only leaves bpm data in column 1.
15. Add custom record length functionality.
16. Update documentation.
17. Remove not needed components.
    1. Audio while recording.
    2. Bottom navigation bar.
18. Found a sucessful method to upload file from client side to python server. Details in ```./server/README.md```.
19. Can now sucessfully transmit video file, but the file will be corrupted.
    1. It is possible to send video through curl without corruption.
    2. Found that with the same file transmitted through cable and through the app, the one through the app has been added a bunch of characters at the start and the end.
    3. After removing dart http boundary the video can be opened.
20. Update app layout, include server link adjustment textfield. Fully tested.