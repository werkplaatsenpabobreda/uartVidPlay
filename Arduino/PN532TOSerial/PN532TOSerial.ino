#include <Wire.h>
#include <Adafruit_PN532.h>

#define SDA_PIN 4
#define SCL_PIN 5
Adafruit_PN532 nfc(SDA_PIN, SCL_PIN);

void setup() {
  Serial.begin(115200);
  Serial.println("INITIALIZING");
  nfc.begin();

  uint32_t version = nfc.getFirmwareVersion();
  if (!version) {
    Serial.println("Didn't find PN532 board");
    while (1)
      ;
  }
  nfc.SAMConfig();
  Serial.println("READY");
}

void loop() {

  uint8_t success;
  uint8_t uid[] = { 0 };
  uint8_t uidLength;

  success = nfc.readPassiveTargetID(PN532_MIFARE_ISO14443A, uid, &uidLength);
  if (success) {
   // Serial.print("Found NFC tag with UID: ");
    for (uint8_t i = 0; i < uidLength; i++) {
      Serial.print(uid[i], HEX);
    }
    Serial.println();
  }
  delay(1000);
}