import os
import socket
import tqdm
from config import Config


def run_server():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.bind((config.serverIP, config.serverPort))
    server.listen()
    print(f"Server is listening on {config.serverIP}:{config.serverPort}")

    while True:
        client, address = server.accept()
        print(f"Client {address} connected.")
        file_name = client.recv(config.receiveFileNameSize).decode()
        print(f"Receiving {file_name}")
        file_size = client.recv(config.receiveFileSize).decode()
        print(f"File size: {file_size}")
        file_bytes = config.receiveFileInitialBytes
        done = False
        progress = tqdm.tqdm(
            range(int(file_size)),
            f"Receiving {file_name}",
            unit=config.tqdmUnit,
            unit_scale=config.tqdmUnitScale,
            unit_divisor=config.tqdmUnitDivisor,
            total=int(file_size),
            leave=config.tqdmLeave,
        )
        while not done:
            data = client.recv(config.receiveFileSize)
            if file_bytes[-5:] == b"<END>":
                done = True
                print("\nDone receiving.")
            elif not data:
                break
            else:
                file_bytes += data
                progress.update(len(data))
        file_name = file_name[:-4] + "tmp.zip"
        with open(os.path.join(config.storeDir, file_name), "wb") as file:
            # with open(os.path.join(config.storeDir, config.tempFileName), "wb") as file:
            file.write(file_bytes)
        client.close()


if __name__ == "__main__":
    config = Config()
    run_server()
