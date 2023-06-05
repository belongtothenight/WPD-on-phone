class Config {
  static const int cameraNum = 1; // 1 is front camera, 0 is back camera
  static const int recordTime = 1; // seconds
  static const String defaultAlbum = "WPD_on_Phone";
  static const String defaultTitle = "WPD on Phone";
  // static const String message_default = "Record $recordTime seconds of video";
  static const String message_recording = "Recording...";
  static const String message_stopped = "Recording finished";
  static const String message_saved = "Video saved to gallery";
  static const String message_zipping = "Zipping video...";
  static const String message_zipped = "Video zipped";
  static const String message_sending = "Sending video to server...";
  static const String message_sent = "Video sent to server";
  static const String serverLink =
      "https://a57b-2001-b400-e30f-e4a5-44bc-99c0-96f1-add5.ngrok-free.app";
  static const int serverTimeout = 5; // seconds
}
