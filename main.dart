import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterBlue Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FlutterBlue Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ScanResult> devices = [];
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;
  StreamSubscription<List<int>>? subscription;
  bool isScanning = false;
  String read_result = "FlutterBlue Demo";

  @override
  void initState() {
    super.initState();
    initBluetooth();
  }

  Future<void> initBluetooth() async {
    FlutterBluePlus.instance.state.listen((state) {
      if (state == BluetoothState.off) {
        print('Bluetooth off');
      } else if (state == BluetoothState.on) {
        print('Bluetooth on');
      }
    });
  }

  Future<void> scan() async {
    devices.clear();
    FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    setState(() {
      isScanning = true;
    });
    FlutterBluePlus.instance.scanResults.listen((scanResult) {
      for (ScanResult r in scanResult) {
        if (!devices.contains(r)) {
          devices.add(r);
        }
      }
      setState(() {});
    });
    await Future.delayed(const Duration(seconds: 4));
    FlutterBluePlus.instance.stopScan();
    setState(() {
      isScanning = false;
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
      services.forEach((service) {
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString() == 'beb5483e-36e1-4688-b7f5-ea07361b26a8') {
            this.characteristic = characteristic;
            characteristic.setNotifyValue(true);
            subscription = characteristic.value.listen((value) {
                    setState(() {
                      read_result = utf8.decode(value);
                    });
                  
                  });
          }
        });
      });
      setState(() {
        connectedDevice = device;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> write() async {
    if (connectedDevice != null && characteristic != null) {
      List<int> message = utf8.encode("Hello World!");
      await characteristic?.write(message);
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      subscription?.cancel();
      await connectedDevice?.disconnect();
      setState(() {
        connectedDevice = null;
        characteristic = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.read_result),

      ),
      body: ListView.builder(
        itemCount: devices.length,
        itemBuilder: (context, index) {
          ScanResult result = devices[index];
          return ListTile(
            title: Text(result.device.name),
            subtitle: Text(result.device.id.toString()),
            onTap: () {
              connectToDevice(result.device);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isScanning ? null : scan,
        child:const Icon(Icons.bluetooth_searching),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Read'),
              onPressed: () async {
                if (connectedDevice != null && characteristic != null) {
                  List<int> value = await characteristic!.read();
                  //print('Read value: $value');
                  setState(() {
                    read_result = utf8.decode(value);
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: write,
              child: const Text('Write'),
            ),
            ElevatedButton(
              
              onPressed: () {
                if (connectedDevice != null && characteristic != null) {
                  characteristic?.setNotifyValue(true);
                  subscription = characteristic?.value.listen((value) {
                    setState(() {
                      read_result = utf8.decode(value);
                    });
                  });
                }
              },
              child: const Text('Notify'),
            ),
            ElevatedButton(
              onPressed: disconnect,
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}