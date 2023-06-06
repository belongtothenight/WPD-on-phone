class Config:
    def __init__(self) -> None:
        # * Server
        self.serverIP = "localhost"
        self.serverPort = 8080
        self.storeDir = "./videos/"
        self.receiveFileNameSize = 8
        self.receiveFileSize = 1024
        self.receiveFileInitialBytes = b""
        self.httpBoundaryString = b"--dart-http-boundary"
        self.httpSplitString = b"\r\n\r\n"
        # * videoProcessor
        self.videoPath = "../videos/"
        self.csvPath = "../result/"
        self.classifierPath = "./haarcascade_frontalface_alt.xml"
        self.frame_l1 = 5
        self.frame_l2 = 10
