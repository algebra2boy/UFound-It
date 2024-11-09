#include <WiFi.h>
#include <ESP32Servo.h>
#include <WebSocketsClient.h>
#include "config.h"

const int ledPin = 2;
#define SERVO1 23

WebSocketsClient webSocket;
Servo myservo;

void setup() {
    Serial.begin(115200);
    pinMode(ledPin, OUTPUT);

    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.println("Connecting to WiFi...");
    }
    Serial.println("Connected to WiFi");

    webSocket.begin(webSocketServer, webSocketPort, "/");
    webSocket.onEvent(webSocketEvent);
    Serial.println("WebSocket setup complete");

    myservo.attach(SERVO1);
    Serial.println("Servo Attached");
    myservo.write(0);
    Serial.println("Servo Position Resetted");
}

void loop() {
    webSocket.loop();
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
            webSocket.sendTXT("Hello from ESP32");
            digitalWrite(ledPin, LOW);
            Serial.println(String("Sending client id: ") + clientId);
            webSocket.sendTXT(String("clientId:") + clientId);
            break;
        case WStype_TEXT:
            Serial.printf("Received command: %s\n", payload);
            if (strcmp((char*)payload, "unlock") == 0) {
                digitalWrite(ledPin, LOW);
                myservo.write(120);
            } else if (strcmp((char*)payload, "lock") == 0) {
                digitalWrite(ledPin, HIGH);
                myservo.write(0);
            }
            break;
        default:
            break;
    }
}
