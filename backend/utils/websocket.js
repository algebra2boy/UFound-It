const WebSocket = require('ws');

let wss;

function initWebSocketServer(server) {
    wss = new WebSocket.Server({ server });

    wss.on('connection', function connection(ws) {
        console.log('WebSocket connection established');

        ws.on('message', function incoming(message) {
            console.log('received: %s', message);
        });

        ws.on('close', function close() {
            console.log('WebSocket connection closed');
        });
    });
}

function broadcast(event, data) {
    wss.clients.forEach(function each(client) {
        if (client.readyState === WebSocket.OPEN) {
            client.send(JSON.stringify({ event, data }));
        }
    });
}

module.exports = { initWebSocketServer, broadcast };