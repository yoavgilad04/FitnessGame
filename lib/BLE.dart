import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

var device_name = "ESP32";
class BLE_Connection {
  BLE_Connection._privateConstructor();

  static final BLE_Connection _instance = BLE_Connection._privateConstructor();

  factory BLE_Connection() {
    return _instance;
  }
  final FlutterBluePlus flutterblueplus = FlutterBluePlus.instance;
  List<ScanResult> devices = [];
  BluetoothDevice? esp_device = null;
  BluetoothCharacteristic? characteristic;
  StreamSubscription<List<int>>? subscription;
  StreamSubscription<BluetoothDeviceState>? connectedSubscription;
  bool isScanning = false;
  bool isNotified = false;
  List<int> read_value = [15,10];
  String s_val = "";

  Future<bool> initBluetooth() async { 
    return await flutterblueplus.isOn;
  }

  Future<String> scan() async {
    if(esp_device != null)
    {
      return "You are already connected to the device";
    }
    devices.clear();
    flutterblueplus.scan().listen((res) {
        if(!devices.contains(res))
        {
          devices.add(res);
        }
     });
    await Future.delayed(const Duration(seconds: 4));
    FlutterBluePlus.instance.stopScan();
    devices.forEach((scan_res) {
        if(scan_res.device.name == device_name)
        {
          esp_device = scan_res.device;
        }
     });
    if(esp_device == null)
    {
      return "Device is not found\n Please make\n sure you turn\n on the main device";
    }
    return "";
  }

  Future<String> connectToDevice() async {
    try {
      await esp_device!.connect();
      connectedSubscription = esp_device!.state.listen((s) { 
          if(!(s == BluetoothDeviceState.connected))
          {
            esp_device!.disconnect();
            esp_device = null;
          }
      });
      List<BluetoothService> services = await esp_device!.discoverServices();
      services.forEach((service) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
            this.characteristic = characteristic;
            characteristic.setNotifyValue(true);
            subscription = characteristic.value.listen((value) {
                  isNotified = true;
                  read_value = value;
                  s_val = utf8.decode(value);
                });
          }
        });
      });
      return "";
    } catch (e) {
      return "Can't connect\n to the device\nPlease try\n on later";
    }
  }

  Future<void> setNotification() async
  {
    await characteristic!.setNotifyValue(true);
    subscription = characteristic!.value.listen((value) {
        isNotified = true;
        read_value = value;
    });
  }

  Future<void> write(List<int> message) async {
    if (esp_device != null && characteristic != null) {
      await characteristic?.write(message);
    }
  }

  Future<void> disconnect() async {
    if (esp_device != null) {
      subscription?.cancel();
      connectedSubscription?.cancel();
      await esp_device?.disconnect();
      esp_device = null;
    }
  }
}