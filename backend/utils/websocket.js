const WebSocket = require('ws');
const http = require('http');

let wss = null;

function initWebSocketServer(express_app) {
    // Create an HTTP server and attach the WebSocket server to it
    const server = http.createServer(express_app);
    wss = new WebSocket.Server({server});

    wss.on('connection', (ws) => {
        console.log('Client connected');

        ws.on('message', (message) => {
            console.log(`Received message: ${message}`);
        });

        ws.on('close', () => {
            console.log('Client disconnected');
        });
    });
}


// Broadcast command to all connected ESP32 clients
function broadcastCommand(command) {
    esp32Clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(command);
        }
    });
}


module.exports = {initWebSocketServer};
