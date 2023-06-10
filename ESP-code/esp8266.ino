#include <espnow.h>
#include <ESP8266WiFi.h>
#include <Adafruit_NeoPixel.h> // for light
#ifdef __AVR__
#include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
#define CHANNEL 1 // the ESP-NOW channel
#define PIN        D4 // the neopixels pin 2 is for D4
#define NUMPIXELS 16  // need to be 16
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
clock_prescale_set(clock_div_1);
#endif
const byte buttonPin = D2; // the number of the pushbutton pin - connect to D2 on the ESP8266
int buttonState = 0; // variables will change to 1 when button is pushed.
bool reciv_is_on = false;
int my_number = 0;

enum GAMEstate {
  GAME1 = 1,
  GAME2,
  GAME3,
  GAME4,
  BLINK,
  TURN_OFF,
  NOT_DECIDED
};

GAMEstate state_of_game = NOT_DECIDED;
int n_to_blink = 0;
int p_to_blink = 0;
enum RGBColor {
  RED = 1,  // Red
  GREEN,  // Green
  BLUE,   // Set the second pixel to blue
  BROWN, // Set the first pixel to BROWN
  CYAN,   // Set the third pixel to Cyan
  WHITE,   // Set the fourth pixel to white
  ORANGE,   // Set the fifth pixel to orange
  PINK,   // Set the sixth pixel to pink
  PURPEL,   // Set the sixth pixel to purpel
};
RGBColor what_color_now = RED;
void turnPixelsOn(RGBColor color) {
  int choice = color;
  int r = 0 , g = 0 , b = 0;
  switch (choice) {
    case 1: // Red
      r = 255;
      break;
    case 2: // Green
      g = 255;
      break;
    case 3: // BLUE
      b = 255;
      break;
    case 4: // BROWN
      r = 200;
      g = 69;
      break;
    case 5: // Cyan
      g = 255;
      b = 255;
      break;
    case 6: // WHITE
      r = 255;
      g = 255;
      b = 255;
      break;
    case 7: // ORANGE
      r = 255;
      g = 165;
      break;
    case 8: // PINK
      r = 255;
      g = 105;
      b = 180;
      break;
    case 9: // PURPEL
      r = 128;
      b = 128;
      break;
    default:
      Serial.println("Invalid choice.\n");
      break;
  }
  r = r / 10;
  g = g / 10;
  b = b / 10;
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(r, g, b));
    pixels.show();   // Send the updated pixel colors to the hardware.
  }
}
void turnPixelsOff() {
  for (int i = 0; i < NUMPIXELS; i++) {
    pixels.setPixelColor(i, pixels.Color(0, 0, 0));
    pixels.show();   // Send the updated pixel colors to the hardware.
  }
}
//flesh color for n times in peac p.
void fleshColor(RGBColor color, int n, int p) {
  if (p == 0) {
    return;
  }
  int del = 1000 / p;
  for (int i = 0; i < n; i++) {
    turnPixelsOn(color);
    delay(del / 2);
    turnPixelsOff();
    delay(del / 2);
  }
}
void printEnterance(bool to_print);

typedef struct {
  uint8_t peer_addr[6]; // Peer MAC address
  uint8_t channel;      // Communication channel
  uint8_t encrypt;      // Encryption enabled flag
  uint8_t reserved[13]; // Reserved for future use
} esp_now_peer_info_t;
enum esp_now_send_status_t {
  ESP_NOW_SEND_SUCCESS,      // Data sent successfully
  ESP_NOW_SEND_FAIL,         // Failed to send data
  ESP_NOW_SEND_QUEUE_FULL,   // The send queue is full, data could not be sent
  ESP_NOW_SEND_TIMEOUT       // The send operation timed out
};
typedef enum {
  ESP_OK = 0,                       // Operation succeeded
  ESP_FAIL = -1,                    // Operation failed
  ESP_ERR_NO_MEM = 0x101,            // Out of memory
  ESP_ERR_INVALID_ARG = 0x102,       // Invalid argument
  ESP_ERR_INVALID_STATE = 0x103,     // Invalid state
  // ... additional error codes
} esp_err_t;

void espnowErrorConnecetionLight() {
  fleshColor(RED, 9, 3);
}

// Init ESP Now with fallback
void InitESPNow() {
  WiFi.disconnect();
  if (esp_now_init() == 0 /*ESP_OK*/) {
    Serial.println("ESPNow Init Success");
  }
  else {
    Serial.println("ESPNow Init Failed");
    espnowErrorConnecetionLight();
    // Retry InitESPNow, add a counte and then restart?
    // InitESPNow();
    // or Simply Restart
    ESP.restart();
  }
}


// Check if the slave is already paired with the master.
// If not, pair the slave with master
uint8_t peer_addr[] = {0x0C, 0xB8, 0x15 , 0x77, 0x71, 0x39};

uint8_t data;// = my_number;
// send data
void sendData() {
  //data++;
  Serial.print("Sending: ");
  Serial.println(data);

  esp_err_t result = (esp_err_t)esp_now_send(peer_addr, &data, sizeof(data));
  Serial.print("Send Status: ");
  if (result == 0/* ESP_OK*/) {
    Serial.println("Success");
  } else if (result == 1 /*ESP_ERR_ESPNOW_NOT_INIT*/) {
    // How did we get so far!!
    Serial.println("ESPNOW not Init.");
  } else if (result == 2/*ESP_ERR_ESPNOW_ARG*/) {
    Serial.println("Invalid Argument");
  } else if (result == 3/*ESP_ERR_ESPNOW_INTERNAL*/) {
    Serial.println("Internal Error");
  } else if (result == 4/*ESP_ERR_ESPNOW_NO_MEM*/) {
    Serial.println("ESP_ERR_ESPNOW_NO_MEM");
  } else if (result == 5/*ESP_ERR_ESPNOW_NOT_FOUND*/) {
    Serial.println("Peer not found.");
  } else {
    Serial.println("Not sure what happened");
    Serial.println(result);
  }
  //delay(100);

}

// callback when data is sent from Master to Slave
void OnDataSent( uint8_t *mac_addr, uint8_t status) {
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  Serial.print("Last Packet Sent to: "); Serial.println(macStr);
  Serial.print("Last Packet Send Status: "); Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
}
// callback when data is recv from Master
void OnDataRecv( uint8_t *mac_addr,  uint8_t *data, uint8_t data_len) {
  reciv_is_on = true;
  what_color_now = static_cast<enum RGBColor>(data[1]);
  state_of_game = static_cast<enum GAMEstate>(data[0]);
  n_to_blink = static_cast<int>(data[2]);
  p_to_blink = static_cast<int>(data[3]);
  /*
    Serial.print("state_of_game: ");
    Serial.println(data[0]);
    Serial.print("color: ");
    Serial.println(data[1]);
  */
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  Serial.print("Last Packet Recv from: "); Serial.println(macStr);
  Serial.print("Last Packet Recv Data: "); Serial.println(*data);
  Serial.println("");
}

void setup() {
  //For communicating with Serial Monitor (in order to print something to the screen using serial monitor)
  Serial.begin(115200);
  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  turnPixelsOff();
  pinMode(buttonPin, INPUT_PULLUP);

  fleshColor(GREEN, 3, 3);

  //Set device in AP and STA mode to begin the comunication
  WiFi.mode(WIFI_AP_STA);

  Serial.println("ESPNow/bidirectional_esp8266");
  byte mac[6];
  // This is the mac address of the Master in Station Mode
  Serial.print("STA MAC: "); Serial.println(WiFi.macAddress());

  // Init ESPNow with a fallback logic
  InitESPNow();

  // Set the role to Controller (ESP8266)
  if (esp_now_set_self_role(ESP_NOW_ROLE_COMBO) != ESP_OK) {
    Serial.println("Error setting role");
    return;
  }
  else {
    Serial.println("esp_now iniial success");
  }

  //  register functions
  esp_now_register_send_cb(OnDataSent);
  esp_now_register_recv_cb(OnDataRecv);
  Serial.println("Ready to send messages");
  WiFi.macAddress(mac);
  Serial.println(mac[3]);
  if (mac[3] == 179)
  {
    data = 2;
  }
  else if (mac[3] == 115)
  {
    data = 3;
  }
  else {
    data = 4;
  }
}

void loop() {

  switch (state_of_game) {
    case 1: // GAME1
      Serial.println("game1");
      //fleshColor(ORANGE, 2, 2);
      game1();
      break;
    case 2: // GAME2
      Serial.println("game2");
      game2();
      break;
    case 3: // GAME3
      break;
      case 4: // GAME4
      break;
    case 5:// BLINK
      Serial.println("BLINK");
      fleshColor(what_color_now, n_to_blink, p_to_blink);
      //  delay(1000);
      state_of_game = NOT_DECIDED;
      break;
    case 6: // TURN_OFF
      Serial.println("TURN_OFF");
      state_of_game = NOT_DECIDED;
      break;
    case 7: // NOT_DECIDED
      Serial.println("NOT DECIDED");
      break;
    default:
      Serial.println("Invalid choice.");
      break;
  }
}

void game1() {
  while (true)
  {
    if (reciv_is_on == true)
    {
      reciv_is_on = false;
      Serial.println("recive_on is false again");
      turnPixelsOn(what_color_now);
      Serial.println("COLOR:");
      Serial.println(what_color_now);
      Serial.println("color turned on");
      bool to_print = true;
      while (1)
      {
        if (state_of_game == BLINK)
        {
          turnPixelsOff();
          return;
        }
        if (state_of_game == TURN_OFF)
        {
          turnPixelsOff();
          return;
        }
        printEnterance(to_print);
        to_print = false;
        buttonState = digitalRead(buttonPin);
        if (buttonState == LOW)
        {
          turnPixelsOff();
          //the game will stop until you reales that button.
          bufferForButton();
          sendData();
          break;
        }
        yield();
      }
      break;
    }
    yield();
  }
  state_of_game = NOT_DECIDED;
}

void game2() {
  while (true)
  {
    if (reciv_is_on == true)
    {
      reciv_is_on = false;
      Serial.println("recive_on is false again");
      turnPixelsOn(what_color_now);
      Serial.println("COLOR:");
      Serial.println(what_color_now);
      Serial.println("color turned on");
      bool to_print = true;
      while (1)
      {
        if (state_of_game == BLINK)
        {
          turnPixelsOff();
          return;
        }
        if (state_of_game == TURN_OFF)
        {
          turnPixelsOff();
          return;
        }
        printEnterance(to_print);
        to_print = false;
        buttonState = digitalRead(buttonPin);
        if (buttonState == LOW)
        {
          turnPixelsOff();
          //the game will stop until you reales that button.
          bufferForButton();
          sendData();
          break;
        }
        yield();
      }
      break;
    }
    yield();
  }
  state_of_game = NOT_DECIDED;
}


void printEnterance(bool to_print) {
  if (to_print == true)
  {
    Serial.println("wait");
    // if i will write here "to_print = false" it will be very stupied, do you know why? because its not a global variable.
  }
  return;
}
void bufferForButton() {
  while (buttonState == LOW) {
    buttonState = digitalRead(buttonPin);
    yield();
  }
}
