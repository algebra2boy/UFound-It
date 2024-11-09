#include <WiFi.h>
#include <ESP32Servo.h>
#include <WebSocketsClient.h>

const char* clientId = "dropbox_number_one";

const char* ssid = "englishorspanish";
const char* password = "ifyoumoveyougae2024";
const char* webSocketServer = "10.0.0.41";  // Example: "192.168.1.100"
const int webSocketPort = 3000;  // Same as the Express server port

const int ledPin = 2;  // GPIO pin connected to the LED
#define SERVO1 23

WebSocketsClient webSocket;
Servo myservo;  // create servo object

void setup() {
    Serial.begin(115200);
    pinMode(ledPin, OUTPUT);  // Set LED pin as output

    // Connect to WiFi
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    // Initialize WebSocket
    webSocket.begin(webSocketServer, webSocketPort, "/");

    // Define WebSocket event handler
    webSocket.onEvent(webSocketEvent);
    Serial.println("WebSocket setup complete");

    myservo.attach(SERVO1);  // attaches servo on pin 23
    Serial.println("Servo Attached");
    myservo.write(0); // reset the servo position
    Serial.println("Servo Position Resetted");
}

void loop() {
    webSocket.loop();  // Keep WebSocket connection alive
}

// WebSocket event handling function
void webSocketEvent(WStype_t type, uint8_t * payload, size_t length) {
    switch (type) {
        case WStype_DISCONNECTED:
            Serial.println("WebSocket Disconnected");
            digitalWrite(ledPin, LOW);
            break;
        case WStype_CONNECTED:
            Serial.println("WebSocket Connected");
            webSocket.sendTXT("Hello from ESP32");  // first message must contain esp32 to identify ws connection type
            digitalWrite(ledPin, LOW);
            Serial.println(String("Sending client id: ") + clientId);
            webSocket.sendTXT(String("clientId:") + clientId);
            break;
        case WStype_TEXT:
            Serial.printf("Received command: %s\n", payload);
            if (strcmp((char*)payload, "unlock") == 0) {
                digitalWrite(ledPin, LOW);  // Turn LED off
                myservo.write(120);
            } else if (strcmp((char*)payload, "lock") == 0) {
                digitalWrite(ledPin, HIGH);   // Turn LED on
                myservo.write(0);
            }
            break;
        default:
            break;
    }
}