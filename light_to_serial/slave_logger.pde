// /dev/tty.usbmodem3a21 skynet-2.dat
// /dev/tty.usbmodem5d11 skynet.dat

int pinRead = 0;
int pinLED = 13;

void setup()
{
    Serial.begin(9600);
    pinMode(pinLED, OUTPUT);
    Serial.println("READY");
}

void loop()
{
    if (Serial.available() > 0) {
        digitalWrite(pinLED, HIGH);
        delay(100);
        int command;
        while (Serial.available() > 0)
            command = Serial.read();
        Serial.println(analogRead(pinRead), DEC);
        digitalWrite(pinLED, LOW);
    }
}

