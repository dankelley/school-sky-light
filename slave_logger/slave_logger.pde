// http://thegrebs.com/docs/arduino-thermistor.html
int pinDivEn = 4;
int pinDivRead = 1;
int pinLED = 13;

void setup()
{
    Serial.begin(9600);
    pinMode(pinLED, OUTPUT);
    pinMode(pinDivEn, OUTPUT);
    Serial.println("READY");
}

void loop()
{
    if (Serial.available() > 0) {
        digitalWrite(pinDivEn, HIGH);
        digitalWrite(pinLED, HIGH);
        delay(100);
        while (Serial.available() > 0)
            int serByte = Serial.read();
        Serial.println(analogRead(pinDivRead));
        digitalWrite(pinDivEn, LOW);
        digitalWrite(pinLED, LOW);
    }
}

