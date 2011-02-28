// used for /dev/tty.usbmodem5d11
void setup()
{
    Serial.begin(9600);
}
void loop()
{
    int val;
    val = analogRead(0);
    Serial.println(val, DEC);
    delay(10000);
}

