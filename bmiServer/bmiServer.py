import http.server, json, traceback
from http.server import BaseHTTPRequestHandler, HTTPServer
import bmiDB

class myHandler(BaseHTTPRequestHandler):
    def _set_headers(self, code = 200):
        self.send_response(code)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        
    def do_GET(self):
        try:
            if self.path == "/data":    #取得資料
                token = int(self.headers['token'])
                print(f'{token} get data')
                data = bmiDB.getData(token)
                j = json.dumps(data)
                resp = j.encode()
                self._set_headers()
                self.wfile.write(resp)
            elif self.path == '/try':
                print('try connect')
                self._set_headers()
            else:
                self._set_headers(502)
        except Exception:
            self._set_headers(502)
            traceback.print_exc()

    def do_POST(self):
        try:
            content_len = int(self.headers.get('Content-Length', 0))
            if self.path == "/enter":   #加入資料
                token = int(self.headers['token'])
                data = self.rfile.read(content_len).decode().split('\n')
                print('entet data', data)
                bmiDB.insertData(token, float(data[0]), float(data[1]), f"{data[2]}\n{data[3]}")
                self._set_headers()
            elif self.path == "/delete":    #刪除資料
                token = int(self.headers['token'])
                data = self.rfile.read(content_len).decode()
                print(f'{token} del data {data}')
                bmiDB.delData(token, data)
                self._set_headers()
            elif self.path == "/login": #登入
                data = self.rfile.read(content_len).decode().split('\n')
                print(f'{data} login')
                userid = bmiDB.login(data[0], data[1])
                resp = str(userid).encode()
                self._set_headers()
                self.wfile.write(resp)
            elif self.path == "/register":  #註冊
                data = self.rfile.read(content_len).decode().split('\n')
                print(f'{data} reg')
                reg = bmiDB.register(data[0], data[1])
                resp = str(reg).encode()
                self._set_headers()
                self.wfile.write(resp)
            elif self.path == '/test':
                data = self.rfile.read(content_len).decode()
                token = int(self.headers['token'])
                print(data)
                print(token)
                self._set_headers()
            else:
                self._set_headers(502)
        except Exception:
            self._set_headers(502)
            traceback.print_exc()

if __name__ == '__main__':
    host = ''
    port = 8000
    HTTPServer((host, port), myHandler).serve_forever()
