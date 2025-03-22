import 'dart:async';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

//------------------------------------------------------------------------------------------------------------//
//----------------------------------------BLE Connection Class------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//

class BLE_Connection extends ChangeNotifier{
  BLE_Connection._privateConstructor();
  static final BLE_Connection _instance = BLE_Connection._privateConstructor();

  factory BLE_Connection() {
    return _instance;
  }
  final FlutterBluePlus flutterblueplus = FlutterBluePlus.instance;
  List<ScanResult> devices = [];
  BluetoothDevice? esp_device;
  BluetoothCharacteristic? characteristic;
  StreamSubscription<List<int>>? subscription;
  StreamSubscription<BluetoothDeviceState>? connectedSubscription;
  bool isScanning = false;
  bool isNotified = false;
  List<int> read_value = [15,10];

//--------------------------------------------Check if Bluetooth is Activated------------------------------//
  Future<bool> initBluetooth() async {
    return await flutterblueplus.isOn;
}


//-------------------------------------------Check if GPS is Activated-------------------------------------//
  Future<bool> initGPS() async
  {
    return await Geolocator.isLocationServiceEnabled();
  }

//-------------------------------------------Looking for ESP32 Device---------------------------------------//
  Future<String> scan() async {
    if(esp_device != null)
    {
      return "You are already connected to the device";
    }
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
    devices.clear();
    flutterblueplus.scan().listen((res) {
        if(!devices.contains(res))
        {
          devices.add(res);
        }
     });
    await Future.delayed(const Duration(seconds: 2));
    FlutterBluePlus.instance.stopScan();
    devices.forEach((scanRes) {
        if(scanRes.device.name == device_name)
        {
          esp_device = scanRes.device;
        }
     });
    if(esp_device == null)
    {
      return "Device is not found\n Please make\n sure you turn\n on the main device";
    }
    return "";
  }

//----------------------------------------Connect to The ESP32 and Listen for Norifications--------------------------------//
/*


            Reading Protocol:
              Message Structure = [First Clicks, Second Clicks(if needed)]
            If 200 is sent => ESP-NOW Error


 */


  Future<String> connectToDevice() async {
    try {
      await esp_device!.connect();
      connectedSubscription = esp_device!.state.listen((s){ 
          if((s == BluetoothDeviceState.disconnected)||(s == BluetoothDeviceState.disconnecting))
          {
            esp_device!.disconnect();
            esp_device = null;
            notifyListeners();
          }
      });
      List<BluetoothService> services = await esp_device!.discoverServices();
      services.forEach((service) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') { // predefined characteristic uuid
            this.characteristic = characteristic;
            characteristic.setNotifyValue(true);
            subscription = characteristic.value.listen((value) {
                  isNotified = true;
                  read_value = value;
                  if(value[0] != 100)
                  {
                    notifyListeners();        
                  }
                });
          }
        });
      });
      return "";
    } catch (e) { // if something went wrong
      return "Can't connect\n to the device\nPlease try\n on later";
    }
  }
//---------------------------------------------------Write Values to ESP32-------------------------------------//
/*
          Writing Protocl:
            Message Structure  [Game, Time, First Color, Second Color(if needed)]

            Game Values:
                1 => Work on Your Fitness
                2 => Work on Your Focus   
                3 => Multi-Player Fitness
                4 => Competition
                5 => Training
                6 => Pause Current Game
                8 => Finish Current Game

            0 <= Time <= 120

            Color Values:
                0 => Random
                3 => Blue
                4 => Brown
                5 => Cyan
                6 => White
                7 => Orange
                8 => Pink
                9 => Purple


*/
  Future<void> write(List<int> message) async {
    if (esp_device != null && characteristic != null) {
      await characteristic?.write(message);
    }
  }

//-------------------------------------------------Disconnect--------------------------------------------------//
  Future<void> disconnect() async {
    if (esp_device != null) {
      subscription?.cancel();
      connectedSubscription?.cancel();
      await esp_device?.disconnect();
      esp_device = null;
    }
  }
}


// void processBackground(dynamic input)
// {
//   final instance = BLE_Connection();
//   instance.connectedSubscription = instance.esp_device!.state.listen((s){ 
//           if((s == BluetoothDeviceState.disconnected)||(s == BluetoothDeviceState.disconnecting))
//           {
//             instance.notify();
//             instance.esp_device!.disconnect();
//             instance.esp_device = null;
//           }
//       });

// }


  