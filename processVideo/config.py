class Config:
    def __init__(self) -> None:
        self.videoPath = "./videos/REC2346057037242107815.mp4"
        self.classifierPath = "./processVideo/haarcascade_frontalface_alt.xml"
        self.savePath = "./result/"
        self.frame_l1 = 20
        self.frame_l2 = 30
