# WPD-on-phone

This repo creates an app service to process app-sent videos and performs BPM extraction and HRV analysis on locally hosted and tunneled servers.

![](multimedia/service_flowchart_n2.png)

Credit: 
1. BPM Extraction is based on [thearn/webcam-pulse-detector](https://github.com/thearn/webcam-pulse-detector/tree/no_openmdao).
2. HRV Analysis is based on [Exploring Heart Rate Variability using Python](https://www.kaggle.com/code/stetelepta/exploring-heart-rate-variability-using-python) and [hrv-analysis library](https://github.com/Aura-healthcare/hrv-analysis).

## Demo

![](multimedia/demo.png)
In this video, only the BPM data was generated, but for the newest code, all three files will be generated like the above picture.
If the following GIF is not displayed, please go to [this folder to download](https://github.com/belongtothenight/WPD-on-phone/blob/main/multimedia/wpd_on_phone.mp4), or go to [YouTube to watch it](https://youtu.be/fCiewFY7d_U).
![](multimedia/wpd_on_phone.gif)

## Software Infrastructure

1. [Flutter 3.10.0](https://flutter.dev/) with [dart 3.0.0](https://dart.dev/) for app development.
2. [Ngrok 3.3.1](https://ngrok.com/) for tunneling.
3. [Python 3.10.8](https://www.python.org/downloads/release/python-3108/) for server hosting, video processing, and data extraction.

## Structure

1. ```./convertHRV```: Use BPM to perform HRV analysis.
2. ```./multimedia```: Pictures and Videos for display.
3. ```./processVideo```: BPM extracting script.
4. ```./release```: Released software.
5. ```./server```: Server to receive videos for processing, including `./processVideo`, and ```./convertHRV```.
6. ```./result```: Extracted data.
7. ```./videos```: Videos for processing.
8. ```./wpd_on_phone```: App to record and send video.



## Links

1. [Learn The Dart Programming Language - Complete Free Course!](https://www.youtube.com/watch?v=JZukfxvc7Mc)
2. [How to setup Flutter, Visual Studio Code, and Android Emulator on Windows - 2022](https://www.youtube.com/watch?v=ZSWfgxrxN0M)
3. [Flutter Basic Training - 12 Minute Bootcamp](https://www.youtube.com/watch?v=1xipg02Wu8s)
4. [Flutter in 100 seconds](https://youtu.be/lHhRhPV--G0)
5. [OpenCV Cascade Classifier](https://docs.opencv.org/3.4/db/d28/tutorial_cascade_classifier.html)
6. [Computer Vision with ML Kit - Flutter In Focus](https://www.youtube.com/watch?v=ymyYUCrJnxU)
7. [Capture photos from Camera using Image Stream with Flutter](https://medium.com/@hugand/capture-photos-from-camera-using-image-stream-with-flutter-e9af94bc2bee)

