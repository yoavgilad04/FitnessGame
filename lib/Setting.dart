
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitnessgame_app/BLE.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConnectPage extends StatefulWidget
{
  final Widget homescreen;
  final bool twice;
  const ConnectPage({super.key, required this.homescreen, required this.twice});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  var title = "Connet To\n Bluetooth";

  @override
  Widget build(BuildContext context) {
    bool success = (title == "Connecting Success!" || title == "The device is\n already connected");
    bool first_reach = (title == "Connet To\n Bluetooth");
    return Scaffold(
      body: Row(children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
                    constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
                    child: IconButton(
                      iconSize: 50,
                      onPressed: (){
                          Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => widget.homescreen),
                                      );
                          },  
                      icon: const Icon(Icons.home)),
                  )
        ),
        const Spacer(),
        Column(children: [
          const Spacer(),
          first_reach ? Text(title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 45),
            softWrap: true,) : 
                Text (title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: success ? Colors.green : Colors.red, fontSize: 30),
                softWrap: true,),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: first_reach ? const Icon(Icons.bluetooth,size: 70,) : 
                    (success ? const Icon(Icons.check_circle,size: 70,color: Colors.green,) : const Icon(Icons.error,size: 70, color: Colors.red,)),
          )
         ,
            const Spacer(),
            Row(children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style,
                  onPressed: () async {
                            final res = await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => LoadingPage()),
                                      );
                      setState(() {
                        title = res;
                    });
                  }, 
                  child:  Text("Connect",
                  style: Theme.of(context).textTheme.bodyMedium)),
            ),
            ],),
            const Spacer(),
        ],),
        const Spacer(flex: 2,),
      ],)
    );
  }
}

class LoadingPage extends StatelessWidget
{
  LoadingPage({super.key});

  String problem = "";

  Future<void> init_and_connect() async
  {
      BLE_Connection i = BLE_Connection();
      if(i.esp_device != null) // already connected
      {
        problem = "The device is\n already connected";
      }
      else{
        if(await i.initBluetooth())
        {
          problem = await i.scan();
          if(problem == "")
          {
            problem = await i.connectToDevice();
            if(problem == "")
            {
              await i.write([7,3,3,3]);
              problem = "Connecting Success!";
            }
          }
        }
      else
      {
        problem = "Please activate\n Bluetooth on\n your device";
      }
    }
      
  }
  
  @override
  Widget build(BuildContext context) {
    init_and_connect().timeout(const Duration(seconds: 8),
    onTimeout: () => {
      
    });
    Timer(const Duration(seconds: 8), () => {
      Navigator.pop(context,problem)
    });
    return Scaffold(
         
            body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
            Text("Connecting",
              style: Theme.of(context).textTheme.titleLarge,),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: const [
                    Spacer(flex: 10,),
                    SpinKitThreeBounce(
                      color: Color.fromARGB(255, 14, 91, 155),
                      size: 30,
                    ),
                    Spacer(flex: 9),
                  ],
                )
            )
                 ],
            ),
         
      
  );
   
  }

}