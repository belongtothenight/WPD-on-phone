import cv2
import os
from config import Config

config = Config()
vidcap = cv2.VideoCapture(config.videoPath)
success, image = vidcap.read()
count = 0
while success:
    #   cv2.imwrite("frame%d.jpg" % count, image)     # save frame as JPEG file
    success, image = vidcap.read()
    print("Read a new frame: ", success)
    count += 1
