const express = require('express');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.json());

/*let clientId = "dropbox_number_one";*/
const clients = new Map();


// WebSocket handling
wss.on('connection', (ws) => {
    console.log('ESP32 connected');
    let clientId = null;

    // Default to unlock the box
    // Uncomment the following line on deployment
    // ws.send("unlock");

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

// Broadcast command to all connected WebSocket clients
function broadcastCommand(command) {
    wss.clients.forEach((client) => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(command);
        }
    });
    console.log("Broadcasted command: ", command);
}


// Sen a lock command to a specific client
function lockClient(clientId){
    const client = clients.get(clientId);
    if(client){
        client.send("lock");
    }
    console.log("lock command sent to client: ", clientId);
}

// Send an unlock command to a specific client
function unlockClient(clientId){
    const client = clients.get(clientId);
    if(client){
        client.send("unlock");
    }
    console.log("unlock command sent to client: ", clientId);
}


// Set up Express routes for HTTP API
app.post('/api/control/lock', (req, res) => {
    let body = req.body;
    if (!body.clientId) {
        res.status(400).send('Missing clientId in request body');
        return;
    }
    let clientId = body.clientId;
    if (!clients.has(clientId)) {
        res.status(404).send('Client not found');
        return;
    }
    lockClient(clientId);
    res.send('Box lock command sent');
});

app.post('/api/control/unlock', (req, res) => {
    let body = req.body;
    if (!body.clientId) {
        res.status(400).send('Missing clientId in request body');
        return;
    }
    let clientId = body.clientId;
    if (!clients.has(clientId)) {
        res.status(404).send('Client not found');
        return;
    }
    boxState = 'unlock';
    unlockClient(clientId);
    res.send('Box unlock command sent');
});


// Start the server
const PORT = process.env.PORT || 9527;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
