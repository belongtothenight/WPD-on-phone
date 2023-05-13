import 'package:opencv_4/opencv_4.dart';

import 'config.dart';
import 'dart:io';

class FindFaceGetPulse {
  var frameIn =
      List<List<double>>.generate(10, (_) => List<double>.filled(10, 0.0));
  var frameOut =
      List<List<double>>.generate(10, (_) => List<double>.filled(10, 0.0));
  var fps = 0;
  var bufferSize = Config.bufferSize;
  var dataBuffer = [];
  var times = [];
  var ttimes = [];
  var samples = [];
  var freqs = [];
  var fft = [];
  var slices = [
    [0]
  ];
  final t0 = DateTime.now();
  var bpms = [];
  var bpm = 0;
  final dpath = Config.dpath;
  var classifierFile = File(Config.dpath);
  // var face_cascade = Cv2.CascadeClassifier();

  void initialize() {
    if (classifierFile.existsSync()) {
      print('Classifier file found.');
    } else {
      print('Classifier file not found.');
    }
  }
}
