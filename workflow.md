# workflow

## List out what this program does.

1. initializing
   1. setup serial communication
   2. setup internet for ip camera
   3. select first camera device as default
   4. load algorithm
      1. initialize variables
      2. load cv2 cascade classifier xml file
   5. setup key controls
   6. proceed to main loop
2. main loop
   1. get a frame from camera
   2. get dimension of retrieved frame
   3. send received frame to processing class
   4. process the frame with processing class
      1. not yet found face
         1. convert input frame into grayscale
         2. put instruction text on output frame
         3. use grayscale input frame to detect face
         4. select forehead section from detected face section
         5. display selected forhead section
      2. found face
         1. put instruction text on output frame
         2. stores means of forehead section in buffer
         3. if enough data in buffer
            1. do algorithm processing
   5. retreive processed frame
   6. display bpm plot if needed
   7. send data via serial connection to processing class if needed
   8. send data via internet connection (udp) if needed
   9. handles key events

## Tasks

- [x] access camera
- [ ] familiar with dart
- [ ] access to cv2 or its replacement
- [ ] load cascade classifier xml file
