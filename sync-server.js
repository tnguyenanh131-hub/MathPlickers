const WebSocket = require("ws");

const PORT = process.env.WS_PORT || 8080;
const wss = new WebSocket.Server({ port: PORT });

console.log(`WebSocket Sync Server running on ws://0.0.0.0:${PORT}`);

wss.on("connection", (ws, req) => {
  const clientIp = req.socket.remoteAddress || "unknown";
  console.log(`Client connected from ${clientIp}`);

  ws.on("message", (rawMessage) => {
    let parsed;
    try {
      parsed = JSON.parse(rawMessage.toString());
    } catch (err) {
      return;
    }

    // Broadcast message to all connected clients (presenter screen, scanners, etc.)
    const payload = JSON.stringify({
      ...parsed,
      serverTimestamp: Date.now()
    });

    wss.clients.forEach((client) => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(payload);
      }
    });
  });

  ws.on("close", () => {
    console.log(`Client disconnected (${clientIp})`);
  });
});
