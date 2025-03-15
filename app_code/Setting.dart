
import 'dart:async';

import 'functions.dart';
import 'package:flutter/material.dart';
import 'BLE.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//----------------------------------------------------------------------------------------------------------//
//------------------------------------------Connection Page-------------------------------------------------//
//----------------------------------------------------------------------------------------------------------//

class ConnectPage extends StatefulWidget
{
  final Widget homescreen;
  const ConnectPage({super.key, required this.homescreen});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  var title = "Connect To\n Bluetooth";

  @override
  Widget build(BuildContext context) {
//--------------------------------------Choose Title According to Connection Result------------------------------------//
    bool success = (title == "Connecting Success!" || title == "The device is\n already connected");
    bool firstReach = (title == "Connect To\n Bluetooth");
    return Scaffold(
      body: backgroundGradient(
        Center(
          child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              homeIcon(widget.homescreen, context),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                      const Spacer(),
        //------------------------------------Title Page-------------------------------------//
                      firstReach ? Text(title,
                                    style: Theme.of(context).textTheme.titleMedium,
                                    softWrap: true,
                                    textAlign: TextAlign.center,) : 
        //-------------------------------------Connection Text Result-------------------//
                            Text (title,
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: success ? const Color.fromARGB(255, 119, 219, 123) : const Color.fromARGB(255, 255, 26, 10), fontSize: 30),
                            softWrap: true,),
        //-------------------------------------Connection Icon Result-------------------//
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: firstReach ? const Icon(Icons.bluetooth,size: 50,) : 
                                (success ? const Icon(Icons.check_circle,size: 50,color: Color.fromARGB(255, 119, 219, 123),) : const Icon(Icons.error,size: 50, color: Color.fromARGB(255, 244, 28, 12),)),
                      ),
        //---------------------------------Displaying Connection Instruction-------------------//
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                          iconSize: 25,
                          onPressed: ()=>{ showConnectionInsr(context) }, 
                          icon: const Icon(Icons.help)),
                      ),
                      const Spacer(),
                        Row(children: [
                           const Spacer(),
        //---------------------------------Go Back--------------------------------------------------//
                           Padding(
                            padding: const EdgeInsets.all(  15.0),
                            child: ElevatedButton(
                                style: Theme.of(context).elevatedButtonTheme.style!.
                                              copyWith(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 251, 47, 32))),
                                onPressed: ()  {
                                          Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => widget.homescreen),
                                                    );
                                  
                                }, 
                                child:  buttonTextDisplay(Text("Back",
                                        style: Theme.of(context).textTheme.displayMedium))
                                ),
                        ),
        //------------------------------------Start Connecting-------------------------------------//
                        Padding(
                          padding: const EdgeInsets.all(15.0),
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
                              child:  buttonTextDisplay(Text("Connect",
                                    style: Theme.of(context).textTheme.displayMedium))
                              ),
                        ),
                        ],),
                        const Spacer(),
                    ],),
                  ),
                ),
              ],),
        )
      )
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
        if(await i.initBluetooth())// Activate Bluetooth
        {
          if(await i.initGPS())   //Activate GPS
          {
            problem = await i.scan();
            if(problem == "")     //Find ESP32 Device
            {
              problem = await i.connectToDevice();
              if(problem == "")   //Connection Success
              {
                  try
                  { 
                    await i.write([9,3,3,3]);  //Default Writing for Connection Check
                    await Future.delayed(const Duration(milliseconds: 3500));
                    if(i.read_value[0] == 100)
                    {
                      problem = "Connecting Success!";
                    }
                    else{
                      //i.disconnect();
                      problem = "Please check your buttons!";
                    }
                  }
                  catch(e)
                  {
                    i.disconnect();
                    problem = "Please check your buttons!";
                  }
              }
            }
          }
          else
          {
              problem = "Please activate\n your GPS!";
          }
        }
      else
      {
        problem = "Please activate\n Bluetooth on\n your device!";
      }
      } 
  }
  
  @override
  Widget build(BuildContext context) {
    init_and_connect().timeout(const Duration(seconds: 11),
    onTimeout: () => {
      
    });
//-----------------------------Limit Connection Period---------------------------//
    Timer(const Duration(seconds: 11), () => Navigator.pop(context,problem)
    );
    return Scaffold(
         
            body: backgroundGradient(Row(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
            Text("Connecting",
              style: Theme.of(context).textTheme.titleMedium,),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: const [
                    Spacer(flex: 10,),
                    SpinKitThreeBounce(
                      color: Colors.white,
                      size: 30,
                    ),
                    Spacer(flex: 9),
                  ],
                )
            )
                 ],
            ),
      ) 
  );
   
  }

}