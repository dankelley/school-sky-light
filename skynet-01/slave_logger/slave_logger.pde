// /dev/tty.usbmodem5d11 skynet-01.dat
// /dev/tty.usbmodem3a21 skynet-02.dat

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
        while (Serial.available() > 0)
            Serial.read();
        delay(100);
        Serial.println(analogRead(pinRead), DEC);
        digitalWrite(pinLED, LOW);
    }
}

