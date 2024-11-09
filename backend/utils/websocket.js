const WebSocket = require('ws');
const http = require('http');

let wss = null;
const esp32Clients = new Map();
const frontendClients = new Set();

function init(express_app) {
    // Create an HTTP server and attach the WebSocket server to it
    const server = http.createServer(express_app);
    wss = new WebSocket.Server({ server });

    wss.on('connection', (ws) => {
        let clientId = null;
        let clientType = null;
        let firstMessage = true;

        ws.on('message', (message) => {
            const msg = message.toString();
            console.log('Received message:', msg);

            if (firstMessage) {
                firstMessage = false;
                // Identify client type (ESP32 or frontend) based on message content
                msg = msg.toLocaleLowerCase();
                if (msg.includes("esp32")) {
                    clientType = 'esp32';
                    console.log("ESP32 client connected");
                } else if (msg.includes("frontend")) {
                    clientType = 'frontend';
                    // currewntly if a frontend client connects, it is added to the set of frontend clients
                    frontendClients.add(ws);
                    console.log("Frontend client connected");
                } else {
                    console.log('Unknown message received from client:', msg);
                }
            }
            if (clientType == 'esp32' && msg.includes("clientId")) {
                    clientId = msg.split(":")[1];
                    esp32Clients.set(clientId, ws);
                    console.log("ESP32 Client ID:", clientId);
                    // Default to unlock the box (comment out in production)
                    ws.send("unlock");
            }
        });

        ws.on('close', () => {
            if (clientType === 'esp32' && clientId !== null) {
                console.log(`ESP32 client with ID ${clientId} disconnected`);
                esp32Clients.delete(clientId);
            } else if (clientType === 'frontend') {
                console.log("Frontend client disconnected");
                frontendClients.delete(ws);
            } else {
                console.log('Client disconnected before sending an ID');
            }
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

// Send unlock command to all ESP32 clients
function unlockAllBox() {
    broadcastCommand("unlock");
}

// Send lock command to all ESP32 clients
function lockAllBox() {
    broadcastCommand("lock");
}

// Send a lock command to a specific ESP32 client
function lockBox(clientId) {
    const client = esp32Clients.get(clientId);
    if (client && client.readyState === WebSocket.OPEN) {
        client.send("lock");
    } else {
        console.log(`ESP32 client with ID ${clientId} not found`);
    }
}

// Send an unlock command to a specific ESP32 client
function unlockBox(clientId) {
    const client = esp32Clients.get(clientId);
    if (client && client.readyState === WebSocket.OPEN) {
        client.send("unlock");
    } else {
        console.log(`ESP32 client with ID ${clientId} not found`);
    }
}

module.exports = { initWebSocketServer, unlockAllBox, lockAllBox, lockBox, unlockBox };

// Usage notes:
// - Call `init(express_app)` with the express app to initialize the WebSocket server.
// - Use `lockBox(clientId/boxId)` or `unlockBox(clientId/boxId)` to send commands to a specific ESP32 client.
// - Use `lockAllBox()` or `unlockAllBox()` to send commands to all ESP32 clients.