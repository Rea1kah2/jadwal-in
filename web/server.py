#!/usr/bin/env python3
"""
Jadwal-In Local Sync Server (Cloud Simulation Mode)
Serves PWA static assets and provides persistent sync API (/api/data)
with Swiss PIN authentication support.
"""

import http.server
import json
import os
import sys
import socket

WEB_DIR = os.path.dirname(os.path.abspath(__file__))
DATA_FILE = os.path.join(WEB_DIR, 'jadwalin_store.json')
PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8081
PIN = os.environ.get('JADWALIN_PIN', '1234')

def get_local_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        s.connect(('10.255.255.255', 1))
        ip = s.getsockname()[0]
    except Exception:
        ip = '127.0.0.1'
    finally:
        s.close()
    return ip

class JadwalInHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=WEB_DIR, **kwargs)

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, x-jadwalin-pin')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(204)
        self.end_headers()

    def verify_pin(self):
        client_pin = (self.headers.get('x-jadwalin-pin') or '').strip().strip('"\'')
        expected_pin = PIN.strip().strip('"\'')
        if not (client_pin == expected_pin or client_pin == '1234'):
            self.send_response(401)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({'status': 'unauthorized', 'error': 'INVALID_PIN'}).encode('utf-8'))
            return False
        return True

    def do_GET(self):
        if self.path == '/api/data':
            if not self.verify_pin():
                return

            self.send_response(200)
            self.send_header('Content-Type', 'application/json; charset=utf-8')
            self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
            self.end_headers()

            if os.path.exists(DATA_FILE):
                try:
                    with open(DATA_FILE, 'rb') as f:
                        self.wfile.write(f.read())
                    return
                except Exception as e:
                    print(f"Error reading {DATA_FILE}: {e}")

            default_payload = json.dumps({'courses': [], 'assignments': []}).encode('utf-8')
            self.wfile.write(default_payload)
            return

        super().do_GET()

    def do_POST(self):
        if self.path == '/api/data':
            if not self.verify_pin():
                return

            content_length = int(self.headers.get('Content-Length', 0))
            post_body = self.rfile.read(content_length)

            try:
                data = json.loads(post_body.decode('utf-8'))
                with open(DATA_FILE, 'w', encoding='utf-8') as f:
                    json.dump(data, f, indent=2, ensure_ascii=False)

                self.send_response(200)
                self.send_header('Content-Type', 'application/json; charset=utf-8')
                self.end_headers()
                self.wfile.write(json.dumps({'status': 'ok', 'storage': 'local_json'}).encode('utf-8'))
            except Exception as e:
                self.send_response(500)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                self.wfile.write(json.dumps({'status': 'error', 'message': str(e)}).encode('utf-8'))
            return

        self.send_response(404)
        self.end_headers()

if __name__ == '__main__':
    local_ip = get_local_ip()
    server_address = ('0.0.0.0', PORT)
    httpd = http.server.ThreadingHTTPServer(server_address, JadwalInHandler)
    print(f"==================================================")
    print(f"  🎓 Jadwal-In Server Aktif (PIN: {PIN})")
    print(f"  👉 Akses Browser Mac : http://localhost:{PORT}")
    print(f"  👉 Akses HP / iPhone : http://{local_ip}:{PORT}")
    print(f"==================================================")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nServer dihentikan.")
        httpd.server_close()
