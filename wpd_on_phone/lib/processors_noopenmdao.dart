import 'package:opencv_4/opencv_4.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

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
  var faceRect = Config.faceRect;
  var lastCenter = [0, 0];
  var lastWH = [0, 0];
  var outputDim = 13;
  var trained = false;
  var idx = 1;
  var findFaces = true;

  void run() async {
    // this.frameIn = frameIn;
  }
}
