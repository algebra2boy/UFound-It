const WebSocket = require('ws');
const http = require('http');

let wss = null;
const clients = new Map();

function init(express_app){
    // takes an express app and adds a websocket server to it
    const server = http.createServer(express_app);
    wss = new WebSocket.Server({ server });

    // WebSocket handling
    wss.on('connection', (ws) => {
        console.log('ESP32 connected');
        let clientId = null;

        // Default to unlock the box
        // Uncomment the following line on deployment
        ws.send("unlock");

        // Listen for the first message to get the client ID
        ws.on('message', (message) => {
            const msg = message.toString();
            console.log('Received from ESP32:', message.toString());
            // Handle messages from the ESP32 if needed
            if (msg.startsWith("clientId")) {
                // if message is clientId:<clientId> (e.g. clientId:dropbox_number_one)
                clientId = msg.split(":")[1];
                clients.set(clientId, ws);
                console.log("Client ID: ", clientId);
            }
        });

        ws.on('close', () => {
            if (clientId !== null) {
                console.log(`Client with ID ${clientId} disconnected`);
                clients.delete(clientId);
            } else {
                console.log('Client disconnected before sending an ID');
            }
        });

    });
}

function checkWss(){
    if(wss === null){
        throw new Error('WebSocket server not initialized');
    }
}

// Broadcast command to all connected WebSocket clients
function broadcastCommand(command) {
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(command);
        }
    });
}

// Send unlock command to all connected clients
function unlockAll(){
    checkWss();
    broadcastCommand("unlock");
}

// Send lock command to all connected clients
function lockAll(){
    checkWss();
    broadcastCommand("lock");
}

// Sen a lock command to a specific client
function lockClient(clientId){
    checkWss();
    const client = clients.get(clientId);
    if(client){
        client.send("lock");
    } else {
        console.log(`Client with ID ${clientId} not found`);
    }
}

// Send an unlock command to a specific client
function unlockClient(clientId){
    checkWss();
    const client = clients.get(clientId);
    if(client){
        client.send("unlock");
    } else {
        console.log(`Client with ID ${clientId} not found`);
    }
}

module.exports = { init, unlockAll, lockAll, lockClient, unlockClient };

// Basic usage
// import the module
// const lock = require('./lock');
// call the init function with the express app
// lock.init(express_app);
// call lockClient(clientId) or unlockClient(clientId) to send the command to a specific client
// clientId is hardcoded in the circuitboard in the locking mechanism, and will be in the second message sent by the ESP32
// The current clientId is dropbox_number_one
// call lockAll() or unlockAll() to send the command to all clients

