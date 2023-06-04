class Config {
  static const int cameraNum = 1; // 1 is front camera, 0 is back camera
  static const int recordTime = 10; // seconds
  static const String defaultTitle = "WPD on Phone";
  // static const String message_default = "Record $recordTime seconds of video";
  static const String message_recording = "Recording...";
  static const String message_stopped = "Recording finished";
  static const String message_saved = "Video saved to gallery";
  static const String message_zipping = "Zipping video...";
  static const String message_zipped = "Video zipped";
  static const String message_sending = "Sending video to server...";
  static const String message_sent = "Video sent to server";
  static const String serverIP = "192.168.171.169";
  static const int serverPort = 8080;
  static const int serverTimeout = 5; // seconds
}
