import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

var device_name = "ESP-32";
class BLE_Connection {
  BLE_Connection._privateConstructor();

  static final BLE_Connection _instance = BLE_Connection._privateConstructor();

  factory BLE_Connection() {
    return _instance;
  }

  List<ScanResult> devices = [];
  BluetoothDevice? esp_device = null;
  BluetoothCharacteristic? characteristic;
  StreamSubscription<List<int>>? subscription;
  bool isScanning = false;
  List<int> read_value = [15,10,5];

  Future<bool> initBluetooth() async {
    //String problem = "";
    /*FlutterBluePlus.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        problem = "Please activate your bluetooth";
      } 
    });*/
    //return problem;
    return await FlutterBluePlus.instance.isOn;
  }

  Future<String> scan() async {
    devices.clear();
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 2));
  
    FlutterBluePlus.instance.scanResults.listen((scanResult) {
      for (ScanResult r in scanResult) {
        if (!devices.contains(r)) {
          devices.add(r);
        }
      }
    });
    await Future.delayed(const Duration(seconds: 2));
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
      List<BluetoothService> services = await esp_device!.discoverServices();
      services.forEach((service) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
            this.characteristic = characteristic;
            characteristic.setNotifyValue(true);
            subscription = characteristic.value.listen((value) {
              read_value = value;
            });
          }
        });
      });
      return "";
    } catch (e) {
      return "Can't connect\n to the device\nPlease try\n on later";
    }
  }

  Future<void> write(List<int> message) async {
    if (esp_device != null && characteristic != null) {
      await characteristic?.write(message);
    }
  }

  Future<void> disconnect() async {
    if (esp_device != null) {
      subscription?.cancel();
      await esp_device?.disconnect();
    }
  }
}