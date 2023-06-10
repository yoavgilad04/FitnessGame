#include <esp_now.h>
#include <esp_system.h>
#include <WiFi.h>
#include <Adafruit_NeoPixel.h> // for light
#include <chrono> // for time
#ifdef __AVR__
#include <avr/power.h> // Required for 16 MHz Adafruit Trinket
#endif
#define CHANNEL 1 // for the ESP-NOW channel
// Which pin on the esp32 is connected to the NeoPixels?
#define PIN        2// the neopixels pin 2 is for D2
// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS 16 // Popular NeoPixel ring size
#define NUMBER_OF_COLORS 9
#define ESP32_LAMP 1
//Setting Up the Neopixels
Adafruit_NeoPixel pixels(NUMPIXELS, PIN, NEO_GRB + NEO_KHZ800);
#if defined(__AVR_ATtiny85__) && (F_CPU == 16000000)
clock_prescale_set(clock_div_1);
#endif
const byte buttonPin = 5;     // the number of the pushbutton pin - connect to D5 on the ESP32
int buttonState = 0;         //variable for reading the pushbutton status - will change to 1 when button is pushed.
#define NUM_OF_PEERS_IN_ARRAY 4
#define ESP_NOW_ROLE_COMBO 3
#define NUM_OF_PEERS 3
int lamp_send = 1;
std::chrono::steady_clock::time_point startTime;  // Global variable
uint8_t peer_addr[NUM_OF_PEERS_IN_ARRAY][6] = {{0x86 , 0xF3, 0xEB , 0xB3 , 0xF3 , 0xF3}, {0x86, 0xF3, 0xEB , 0x73, 0x4B, 0xE2}, {0x52, 0x02, 0x91, 0x4E, 0x71, 0x33}, {0x8C , 0xAA, 0xB5 , 0xC6 , 0x8C , 0xAF}}; //{0x0C, 0xB8, 0x15 , 0x77, 0x71 , 0x39},
enum GAMEstate {
  GAME1 = 1,
  GAME2,
  GAME3,
  GAME4,
  BLINK,
  TURN_OFF,
  NOT_DECIDED
};
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

//{ // functions declaretion:
int game1(int random_or_color);
int turnOnAndWaitUntillButtonPushed(int lamp_number, RGBColor color);
int game2();
int who_is_first(int lamp_with_chosen_color);
void putDiffrentColorsInArray(RGBColor chosen_color, RGBColor colors[]);

void turnPixelsOn(RGBColor color);
int turnOnLampInColor(int lamp_number, RGBColor color);
void turnPixelsOff();
void turnAllOfThemeOff();
void fleshColor(RGBColor color, int n, int p);
void blinkColorToEveryone(RGBColor color, int n, int p);
void notPreesOnTimeLight();
void espnowConnecetSucssefullyLight();
void espnowErrorConnecetionLight();

void bufferForButton();
void startTimer();
int TimePassed();
bool TimeExceeded();
void printEnterance(bool to_print); //}

// Init ESP Now with fallback
void InitESPNow() {
  WiFi.disconnect();
  if (esp_now_init() == ESP_OK) {
    //espnowConnecetSucssefullyLight();
    Serial.println("ESPNow Init Success");
  }
  else {
    Serial.println("ESPNow Init Failed");
    espnowErrorConnecetionLight();
    ESP.restart();
  }
}

bool button_has_been_pushed = false;
int max_rounds_of_the_game = 5000;
int max_time_of_the_game = 15;
GAMEstate state_of_game = NOT_DECIDED;
RGBColor my_color = GREEN;
GAMEstate gameop = NOT_DECIDED;
int n_to_blink = 0;
int p_to_blink = 0;

uint8_t data_inf[4] = {0};

void sendData(int i) {
  data_inf[0] = static_cast<uint8_t>(gameop);
  data_inf[1] = static_cast<uint8_t>(my_color);
  data_inf[2] = n_to_blink;
  data_inf[3] = p_to_blink;

  Serial.print("Sending color number: ");
  Serial.println(data_inf[1]);

  esp_err_t result = esp_now_send(peer_addr[i], data_inf, sizeof(data_inf));

  Serial.print("Send Status: ");
  if (result == ESP_OK) {
    Serial.println("Success");
  } else if (result == ESP_ERR_ESPNOW_NOT_INIT) {
    // How did we get so far!!
    espnowErrorConnecetionLight();
    Serial.println("ESPNOW not Init.");
  } else if (result == ESP_ERR_ESPNOW_ARG) {
    espnowErrorConnecetionLight();
    Serial.println("Invalid Argument");
  } else if (result == ESP_ERR_ESPNOW_INTERNAL) {
    espnowErrorConnecetionLight();
    Serial.println("Internal Error");
  } else if (result == ESP_ERR_ESPNOW_NO_MEM) {
    espnowErrorConnecetionLight();
    Serial.println("ESP_ERR_ESPNOW_NO_MEM");
  } else if (result == ESP_ERR_ESPNOW_NOT_FOUND) {
    espnowErrorConnecetionLight();
    Serial.println("Peer not found.");
  } else {
    espnowErrorConnecetionLight();
    Serial.println("Not sure what happened");
  }
}

// callback when data is sent from Master to Slave
void OnDataSent(const uint8_t *mac_addr, esp_now_send_status_t status) {
  //fleshColor(B, 5, 10);
  char macStr[18];
  snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
           mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
  Serial.print("Last Packet Sent to: "); Serial.println(macStr);
  Serial.print("Last Packet Send Status: "); Serial.println(status == ESP_NOW_SEND_SUCCESS ? "Delivery Success" : "Delivery Fail");
  if (status != ESP_NOW_SEND_SUCCESS)
  {
    //ofek send via bluetooth that it is fail.
    Serial.println("going to reset");
    fleshColor(RED, 6, 6);
    //ofek tell the user that we are going to a restart.
    ESP.restart();
  }
}
void OnDataRecv(const uint8_t *mac_addr, const uint8_t *data, int data_len) {
  switch (state_of_game) {
    case 1: //GAME1
      {
        /* danger! danger! ---- if you pu her: "button_has_been_pushed = true;" you will
          have a big bug in your progrem! put thet sentance at the end of this function*/
        Serial.print("change buttonstat_elsewhere to false");
        char macStr[18];
        snprintf(macStr, sizeof(macStr), "%02x:%02x:%02x:%02x:%02x:%02x",
                 mac_addr[0], mac_addr[1], mac_addr[2], mac_addr[3], mac_addr[4], mac_addr[5]);
        Serial.print("Last Packet Recv from: "); Serial.println(macStr);
        Serial.print("Last Packet Recv Data: "); Serial.println(*data);
        Serial.println("");

        button_has_been_pushed = true;
      }
    case 2: // GAME2
      lamp_send = *data;
      button_has_been_pushed = true;
      break;
    case 3: // GAME3
      break;
    case 4: //GAME4
      break;
    case 5: //BLINK
      break;
    case 6: // TURN_OFF
      break;
    case 7: // NOT_DECIDED
      break;
    default:
      Serial.println("Invalid choice.");
      break;
  }
}

////////////////////////////////////////////////////
/*
  Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleNotify.cpp
  Ported to Arduino ESP32 by Evandro Copercini
  updated by chegewara and MoThunderz
*/
/*
  #include <BLEDevice.h>
  //#include <BLEServer.h>
  //#include <BLEUtils.h>
  //#include <BLE2902.h>

  BLEServer* pServer = NULL;
  BLECharacteristic* pCharacteristic = NULL;
  //BLEDescriptor *pDescr;
  //BLE2902 *pBLE2902;

  bool deviceConnected = false;
  bool oldDeviceConnected = false;
  uint32_t value = 60;

  // See the following for generating UUIDs:
  // https://www.uuidgenerator.net/

  #define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
  #define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

  class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
  };

  class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCharacteristic) {
      std::string value = pCharacteristic->getValue();
      state_of_game = GAME1;
      if (value.length() > 0) {
        Serial.println("***");
        Serial.print("New value: ");
        for (int i = 0; i < value.length(); i++)
          Serial.print(value[i]);

        Serial.println();
        Serial.println("***");
      }
    }
  };
*/
/////////////////////////////////////////////////////
// Add the ESP8266 as a peer
esp_now_peer_info_t peer[NUM_OF_PEERS];
void setup() {

  delay(2000);
  Serial.begin(115200);
  /*
    // Create the BLE Device
    BLEDevice::init("ESP32");
    // Create the BLE Server
    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    // Create the BLE Service
    BLEService *pService = pServer->createService(SERVICE_UUID);

    // Create a BLE Characteristic
    pCharacteristic = pService->createCharacteristic(
                        CHARACTERISTIC_UUID,
                        BLECharacteristic::PROPERTY_NOTIFY |
                        BLECharacteristic::PROPERTY_READ |
                        BLECharacteristic::PROPERTY_WRITE
                      );

    // Define the callbacks

    pCharacteristic->setCallbacks(new MyCallbacks());
    // Start the service
    pService->start();

    // Start advertising
    BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->setScanResponse(false);
    pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
    BLEDevice::startAdvertising();
    Serial.println("Waiting a client connection to notify...");

  */
  ///////////////////////////////////////////////////
  pixels.begin(); // INITIALIZE NeoPixel strip object (REQUIRED)
  turnPixelsOff();
  // initialize the pushbutton pin as an input:
  pinMode(buttonPin, INPUT);

  //Set device in AP and STA mode to begin the comunication
  WiFi.mode(WIFI_AP_STA);

  Serial.println("ESPNow/bidirectional_esp32");

  // This is the mac address of the Master in Station Mode
  Serial.print("STA MAC: "); Serial.println(WiFi.macAddress());

  // Init ESPNow with a fallback logic
  InitESPNow();

  // Set the role to Controller (ESP8266)
  /* if (esp_now_set_self_role(ESP_NOW_ROLE_COMBO) != ESP_OK) {
     Serial.println("Error setting role");
     return;
    }
    else {
     Serial.println("esp_now iniial success");
    }*/

  //  register functions
  esp_now_register_send_cb(OnDataSent);
  esp_now_register_recv_cb(OnDataRecv);


  for (int i = 0; i < NUM_OF_PEERS; i++)
  {
    memcpy(peer[i].peer_addr, peer_addr[i], 6);
    peer[i].channel = 0;
    peer[i].encrypt = false;
    if (esp_now_add_peer(&peer[i]) != ESP_OK) {
      Serial.print("Failed to add peer number ");
      Serial.println(i + 2);
      Serial.print("not initiated anyone after that include.");
      //ofek tell the user that we are going to a restart.
      ESP.restart();
      return;
    }
    else {
      Serial.print("added peer number: ");
      Serial.println(i + 2);
    }
  }

  Serial.println("Ready to send messages");

  state_of_game = NOT_DECIDED;
}


RGBColor chosen_color = WHITE; //okef give me!

void loop() {
  int res, res1, res2;
  int color1 = 7, color2 = 6;
  switch (state_of_game) {
    case 1: // GAME1
      fleshColor(ORANGE, 3, 3);
      Serial.println("game1");
      // ofek, put the color number insaide the game, if you put 0 than its a random color, and put time in the global varibal: "max_time_of_the_game".
      res = game1(0);
      //neet to send ofek res.
      state_of_game = NOT_DECIDED;
      break;
    case 2: // GAME2
      fleshColor(PURPEL, 3, 3);
      Serial.println("game2");
      game2();
      state_of_game = NOT_DECIDED;
      break;
    case 3: // GAME3

      state_of_game = NOT_DECIDED;
      break;
    case 4: // GAME4
      fleshColor(BLUE, 3, 3);
      state_of_game = GAME1;
      res1 = game1(color1);
      res2 = game1(color2);
      delay(2000);
      ((res1 == res2) ? blinkColorToEveryone(GREEN, 3, 1) : (blinkColorToEveryone(((res1 > res2) ? static_cast<enum RGBColor>(color1) : static_cast<enum RGBColor>(color2)), 3, 1))) ;
      state_of_game = NOT_DECIDED;
      //send to ofek res1 and res2.
      break;
    case 5: // BLINK
      break;
    case 6: // TURN_OFF
      break;
    case 7: // NOT_DECIDED
      fleshColor(BROWN, 3, 3);
      delay(1000);
      state_of_game = GAME4;
      break;
    default:
      Serial.println("Invalid choice.");
      break;
  }
}


int game1(int random_or_color) {
  Serial.println("start timer");
  startTimer();  // Start the timer

  int lamp_number = 0, rounds = 0 , clicks = 0;
  RGBColor color;
  while (rounds < max_rounds_of_the_game && (TimeExceeded() == false))
  {
    lamp_number = random(1, NUM_OF_PEERS + 2); // 1 or 2 or 3 or ... 5-1
    color = (random_or_color) ? static_cast<enum RGBColor>(random_or_color) : static_cast<enum RGBColor>(random(3, NUMBER_OF_COLORS + 1));
    Serial.print("sending to esp number:  ");
    Serial.println(lamp_number);
    button_has_been_pushed = false;
    clicks += turnOnAndWaitUntillButtonPushed(lamp_number, color);
    rounds++;
  }

  if (TimeExceeded() == true)
    blinkColorToEveryone(RED, 3, 1);
  else
    // you took all rounds possible!
    blinkColorToEveryone(GREEN, 3, 1);
  return clicks;
}

int turnOnAndWaitUntillButtonPushed(int lamp_number, RGBColor color) {
  Serial.println("turnOnAndWaitUntillButtonPushed");
  int prees_or_not = 0;
  if (lamp_number == ESP32_LAMP) // not sending information to anyone so its a specipice case
  {
    turnPixelsOn(color);
    prees_or_not += waitForRespond();
  }
  else // sending to an esp8266.
  {
    my_color = (color);
    gameop = GAME1;// or i can write just statu_of_game - think about that.
    button_has_been_pushed = false;
    sendData(lamp_number - 2);
    bool to_print = true;
    while (1)
    {
      printEnterance(to_print);
      to_print = false;
      if (button_has_been_pushed == true)
      {
        button_has_been_pushed = false;
        prees_or_not++;;
        Serial.println("stop");
        break;
      }
      if (TimePassed() >= max_time_of_the_game)
      {
        Serial.println("Time out!!!!!!!!!");
        //notPreesOnTimeLight();
        //turn_off_lights_and_end_game();
        prees_or_not = 0; //just for readability reasons.
        break;
      }
    }
  }
  return prees_or_not;
}
int waitForRespond() {
  while (1)
  {
    buttonState = digitalRead(buttonPin);
    if (buttonState == LOW)
    {
      turnPixelsOff();
      bufferForButton();
      return 1;
    }
    if (TimePassed() >= max_time_of_the_game)
    {
      Serial.println("Time out!!!!!!!!!");
      return 0;
    }
  }
}


int game2() {
  Serial.println("start timer");
  startTimer();  // Start the timer

  int lamp_with_chosen_color = 0, rounds = 0 , score = 0;
  RGBColor colors[NUM_OF_PEERS + 1];

  while ((rounds < max_rounds_of_the_game) && (TimeExceeded() == false))
  {
    //put colors in an array that all of them are different from one another and different from the chosen color of course.
    putDiffrentColorsInArray(chosen_color, colors);

    // the lamp with the chosen color !
    lamp_with_chosen_color = random(1, NUM_OF_PEERS + 2);
    button_has_been_pushed = false;
    int color_index = 0;
    for (int i = 1; i < NUM_OF_PEERS + 2; i++) {
      if (i == lamp_with_chosen_color) //that lamp will light up with the chosen color.
        continue;
      turnOnLampInColor(i, colors[color_index++]);
    }
    //turning on the lamp with the chosen color !
    turnOnLampInColor(lamp_with_chosen_color, chosen_color);

    // if the correct lamp pushed first, will return 1, if other lamp has been pushed first, return -1,if time end, return 0.
    /*i give ofek*/int faild_or_secced = who_is_first(lamp_with_chosen_color);
    score += faild_or_secced;
    //send ofek the score.
    Serial.print("score is: ");
    Serial.println(score);

    //turning off all lamps.
    turnAllOfThemeOff();

    rounds++;
  }

  //send statistics via bluetooth.
  if (TimeExceeded() == true)
    blinkColorToEveryone(RED, 3, 1);
  else
    // you took all rounds possible!
    blinkColorToEveryone(GREEN, 3, 1);
  return score;
}


void turnAllOfThemeOff() {
  gameop = TURN_OFF;
  turnPixelsOff();
  for (int i = 0; i < NUM_OF_PEERS; i++)
  {
    sendData(i);
  }
}
int who_is_first(int lamp_with_chosen_color) {
  int score = 0;
  while (1) {
    if (button_has_been_pushed == true) {
      button_has_been_pushed = false;
      score =  ((lamp_with_chosen_color == lamp_send) ? 1 : -1);
      break;
    }
    buttonState = digitalRead(buttonPin);
    if (buttonState == LOW)
    {
      turnPixelsOff();
      bufferForButton();
      /*while (buttonState == LOW) {
        buttonState = digitalRead(buttonPin);
        }*/
      score = ((lamp_with_chosen_color == 1) ? 1 : -1);
      break;
    }
    if ((TimePassed() >= max_time_of_the_game)) {
      break;
    }
  }
  return score;
}

int turnOnLampInColor(int lamp_number, RGBColor color) {
  if (lamp_number == ESP32_LAMP) // not sending information to anyone so its a specipice case
    turnPixelsOn(color);

  else // sending to an esp8266.
  {
    my_color = (color);
    gameop = GAME2;// it dosent really matter if its GAME1 or GAME2.
    button_has_been_pushed = false;
    sendData(lamp_number - 2);
  }
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
  }
  return;
}

bool TimeExceeded() {
  if ((TimePassed() >= max_time_of_the_game)) {
    return true;
  }
  return false;
}
void putDiffrentColorsInArray(RGBColor chosen_color, RGBColor colors[]) {
  int index = 1;
  while (1) {
    colors[index - 1] = static_cast<enum RGBColor>(random(3, NUMBER_OF_COLORS + 1));
    switch (index) {
      case 1:
        if (colors[index - 1] != chosen_color)
          index++;
        break;
      case 2: // GAME2
        if (colors[index - 1] != chosen_color && colors[index - 1] != colors[index - 2])
          index++;
        break;
      case 3:
        if (colors[index - 1] != chosen_color && colors[index - 1] != colors[index - 2] && colors[index - 1] != colors[index - 3])
          index++;
        break;
      default:
        Serial.println("Invalid choice.");
        break;
    }
    if (index == NUM_OF_PEERS + 1)
      break;
  }
  return;
}
void blinkColorToEveryone(RGBColor color, int n, int p) {
  my_color = color;
  gameop = BLINK;
  n_to_blink = n;
  p_to_blink = p;

  for (int i = 0; i < NUM_OF_PEERS; i++)
  {
    sendData(i);
  }
  fleshColor(color, n, p);
}
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
void notPreesOnTimeLight() {
  fleshColor(RED, 3, 3);
  return;
}
void espnowConnecetSucssefullyLight() {
  fleshColor(GREEN, 3, 3);
}
void espnowErrorConnecetionLight() {
  fleshColor(RED, 10, 2);
}
void startTimer() {
  startTime = std::chrono::steady_clock::now();  // Set the start time
  return;
}
int TimePassed() {

  auto currentTime = std::chrono::steady_clock::now();  // Get the current time
  auto elapsedSeconds = std::chrono::duration_cast<std::chrono::seconds>(currentTime - startTime).count();  // Calculate the elapsed seconds
  return elapsedSeconds;
}
