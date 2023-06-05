# Video Receiving and Processing Server

## Method

Steps from [Running a simple python server with post file upload functionality](https://youtu.be/EH9xDJbIbl8) works file for LAN network testing.

1. Download [ngrok.exe](https://ngrok.com/download).
2. Get the authentication key from [ngrok/yourauthtoken](https://dashboard.ngrok.com/get-started/your-authtoken).
3. On the server side, go to the directory of "ngrok.exe" and type ```ngrok.exe authtoken <yourToken>``` in CLI.
4. On the server side, go to the same directory, type ```ngrok.exe http <portNum>``` in CLI to monitor network activity.
5. On the server side, prepare a Python server with the ability to receive files from <https://pastebin.com/raw/jy1a55VJ> and run it on the specified port.
6. On the client side, prepare a file for uploading.
7. On the client side, type ```curl -X POST "<ngrokForwardingLink>/newName.txt" --data-binary "@file_to_upload"``` in CLI to upload a single file to the server.
8. All of the actions like GET, POST, etc can be observed on the server side.
