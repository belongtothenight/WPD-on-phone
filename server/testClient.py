import os
import socket
import zlib
from config import Config

config = Config()
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((config.serverIP, config.serverPort))

client.send(config.demoFileName.encode())
client.send(
    str(os.path.getsize(os.path.join(config.storeDir, config.demoFileName))).encode()
)

with open(os.path.join(config.storeDir, config.demoFileName), "rb") as file:
    file_bytes = file.read()
    print(file_bytes)
    print(f"File size: {len(file_bytes)}")
    client.send(file_bytes)
client.send(b"<END>")

client.close()

print("Done!")
