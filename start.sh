#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

HTTP_PORT="${HTTP_PORT:-8000}"
WS_PORT="${WS_PORT:-8080}"
OPEN_BROWSER="${OPEN_BROWSER:-1}"
PRESENTER_URL="http://localhost:${HTTP_PORT}/frontend/presenter-screen.html"

get_lan_ipv4() {
  local ip=""
  if command -v ip >/dev/null 2>&1; then
    ip="$(ip -4 route get 1.1.1.1 2>/dev/null | awk '{for (i=1; i<=NF; i++) if ($i=="src") {print $(i+1); exit}}')"
  fi
  if [ -z "$ip" ] && command -v ipconfig >/dev/null 2>&1; then
    ip="$(ipconfig getifaddr en0 2>/dev/null || true)"
    [ -z "$ip" ] && ip="$(ipconfig getifaddr en1 2>/dev/null || true)"
  fi
  if [ -z "$ip" ] && command -v hostname >/dev/null 2>&1; then
    ip="$(hostname -I 2>/dev/null | tr ' ' '\n' | grep -E '^([0-9]{1,3}\.){3}[0-9]{1,3}$' | grep -v '^127\.' | head -n 1 || true)"
  fi
  if [ -z "$ip" ] && command -v python3 >/dev/null 2>&1; then
    ip="$(python3 -c 'import socket; s=socket.socket(socket.AF_INET,socket.SOCK_DGRAM); s.connect(("8.8.8.8",80)); print(s.getsockname()[0]); s.close()' 2>/dev/null || true)"
  fi
  [ -z "$ip" ] && echo "<IP-MAY-TINH>" || echo "$ip"
}

LAN_IP="$(get_lan_ipv4)"
echo "=================================================="
echo "  PLICKERS MATH SUITE - KHOI DONG HE THONG"
echo "=================================================="
echo "Thu muc du an : $SCRIPT_DIR"
echo "IPv4 LAN      : ${LAN_IP}"
echo "Web Server    : http://localhost:${HTTP_PORT}"
echo "WebSocket Port: ${WS_PORT}"
echo ""

if ! command -v node >/dev/null 2>&1; then
  echo "[LOI] Khong tim thay Node.js."
  exit 1
fi

if [ ! -d "$SCRIPT_DIR/server/node_modules/ws" ]; then
  echo "[INFO] Dang cai dat 'ws'..."
  (cd "$SCRIPT_DIR/server" && npm install --silent)
fi

HTTP_PID=""
WS_PID=""
cleanup() {
  [ -n "$WS_PID" ] && kill "$WS_PID" 2>/dev/null || true
  [ -n "$HTTP_PID" ] && kill "$HTTP_PID" 2>/dev/null || true
  exit 0
}
trap cleanup INT TERM EXIT

node "$SCRIPT_DIR/server/sync-server.js" &
WS_PID=$!
sleep 0.5

if command -v python3 >/dev/null 2>&1; then
  python3 -m http.server "$HTTP_PORT" --directory "$SCRIPT_DIR" &
  HTTP_PID=$!
else
  npx --yes http-server "$SCRIPT_DIR" -p "$HTTP_PORT" -c-1 &
  HTTP_PID=$!
fi

sleep 0.8
if [ "$OPEN_BROWSER" = "1" ]; then
  command -v open >/dev/null 2>&1 && open "$PRESENTER_URL" >/dev/null 2>&1 || true
  command -v xdg-open >/dev/null 2>&1 && xdg-open "$PRESENTER_URL" >/dev/null 2>&1 || true
fi

echo "[SAN SANG] Mo trinh duyet tai:"
echo "  - Man hinh TV / PC : ${PRESENTER_URL}"
echo "  - In bo the A/B/C/D: http://localhost:${HTTP_PORT}/mobile-scanner/print-cards.html"
echo "  - Dien thoai quet   : http://${LAN_IP}:${HTTP_PORT}/mobile-scanner/index.html"
wait "$WS_PID" "$HTTP_PID"
