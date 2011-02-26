// Master-slave with 'n' points averaged per value
const int n = 4;
int pinRead = 1;
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
        float mean = 0.0;
        for (int i = 0; i < n; i++)
            mean = mean + analogRead(pinRead); 
        mean = mean / n;
        Serial.println(int(mean), DEC);
        digitalWrite(pinLED, LOW);
    }
}

