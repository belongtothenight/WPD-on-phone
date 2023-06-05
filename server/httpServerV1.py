from http.server import HTTPServer, BaseHTTPRequestHandler
from config import Config

config = Config()


class VideoHTTP(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        # self.send_header("Content-type", config.demoFileName)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        # with open(config.demoFileName, "rb") as f:
        #     self.wfile.write(f.read())
        self.wfile.write(b"<html><body><h1>Connection works!</h1></body></html>")

    def deal_post_data(self):
        # need to receive filename, filesize, and the entire file
        pass


server = HTTPServer((config.serverIP, config.serverPort), VideoHTTP)
print("Starting server, use <Ctrl-C> to stop")
server.serve_forever()
server.server_close()
print("Server stopped")
