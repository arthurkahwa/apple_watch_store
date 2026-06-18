#!/usr/bin/env python3
"""Simple mock API server for AppleWatchStore screenshot automation."""
import json
import http.server

# Extract response data from Mockoon export
with open("docs/WatchStoreAPI.json") as f:
    api = json.load(f)

RESPONSES = {}
for route in api.get("routes", []):
    endpoint = "/" + route["endpoint"]
    for resp in route.get("responses", []):
        RESPONSES[endpoint] = resp.get("body", "[]")

class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        path = self.path.split("?")[0]
        if path in RESPONSES:
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(RESPONSES[path].encode())
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        pass  # suppress logs

if __name__ == "__main__":
    server = http.server.HTTPServer(("127.0.0.1", 3000), Handler)
    print("Mock server on http://127.0.0.1:3000")
    server.serve_forever()
