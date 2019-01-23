/* For CAP1188 board */
#include <Wire.h>
#include <SPI.h>
#include <Adafruit_CAP1188.h>
#define CAP1188_RESET  9 // Reset Pin is used for I2C or SPI
// For I2C, connect SDA to your Arduino's SDA pin, SCL to SCL pin
// On UNO/Duemilanove/etc, SDA == Analog 4, SCL == Analog 5
Adafruit_CAP1188 cap = Adafruit_CAP1188(CAP1188_RESET); // Use I2C, with reset pin

/* For serial communication */
char separator[] = ",";

/* For spoon */
#define SPOON_POW  A1 //on Uno
#define SPOON_TRIG  4 //on CAP1188

/* For tray */
#define TILT  2 //on Uno

void setup()
{
  Serial.begin(115200);
  pinMode(SPOON_POW, INPUT_PULLUP); //spoon power
  pinMode(TILT, INPUT_PULLUP);  //Tilt button

  // Initialize the sensor, if using i2c you can pass in the i2c address
  // if (!cap.begin(0x28)) {
  if (!cap.begin()) {
//    Serial.println("CAP1188 not found");
    while (1);
  }
//  Serial.println("CAP1188 found!");
}

void loop()
{
  
  int spoonVal = analogRead(SPOON_POW);
  // apply the calibration to the sensor reading
  spoonVal = map(spoonVal, 190, 530, 750, 0);
  // in case the sensor value is outside the range seen during calibration
  spoonVal = constrain(spoonVal, 0, 1023);
  Serial.print(spoonVal, DEC); //Actual value
  Serial.print(separator);//Separate different readings

  int tiltFlg = digitalRead(TILT);
  Serial.print(tiltFlg); //Actual value

  uint8_t touched = cap.touched();
//  if (touched == 0) {
//    // No touch detected
//    Serial.print(0);
//    Serial.println();//Separate different readings
//    delay(50);
//    return;
//  }
  for (uint8_t i=0; i<8; i++) {
    Serial.print(separator);//Separate different readings
    if (touched & (1 << i)) {
      Serial.print(1);
    } else {
      Serial.print(0);
    }
  }
    
  Serial.println();//Separate different readings
  
  delay(50);
}
