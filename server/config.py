class Config:
    def __init__(self) -> None:
        self.serverIP = "localhost"
        self.serverPort = 8080
        self.storeDir = "./videos/"
        self.receiveFileNameSize = 8
        self.receiveFileSize = 1024
        self.receiveFileInitialBytes = b""
        self.tempFileName = "temp.mp4"
        self.demoFileName = "demo.zip"
        self.tqdmUnit = "B"
        self.tqdmUnitScale = True
        self.tqdmUnitDivisor = 1000
        self.tqdmLeave = False
