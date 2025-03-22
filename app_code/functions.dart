

import 'BLE.dart';
import 'constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//-------------------Dropdown values-----------------------//
List<Color> getColor(String value)
  {
    List<Color> chosen = [Colors.amber, Colors.amber];
    switch(value) 
    {
        case 'Blue' : chosen = [const Color.fromARGB(255, 120, 108, 231), Colors.blue]; break;
        case 'Orange' : chosen = [Colors.orange, const Color.fromARGB(255, 252, 190, 97)]; break;
        case 'Purple' : chosen = [Colors.purple, const Color.fromARGB(255, 188, 114, 201)]; break;
        case 'Brown' : chosen = [const Color.fromARGB(255, 131, 102, 92), const Color.fromARGB(255, 187, 144, 127)]; break;
        case 'Pink' : chosen = [Colors.pink, const Color.fromARGB(255, 251, 117, 161)]; break;
        case 'Cyan' : chosen = [Colors.cyan, Colors.cyanAccent]; break;
        case 'White' : chosen = [ Colors.white,const Color.fromARGB(255, 255, 234, 234)]; break;
        case 'Random' : chosen = rainbowColors; break;
        default : Colors.amber;
    }
    return chosen;
  }

  int getColorSerial(String s)
  {
    int chosen = 0;
    switch(s) 
    {
        case 'Random' : chosen = 0;  break;
        case 'Blue' :   chosen = 3;  break;
        case 'Brown' :  chosen = 4;  break;
        case 'Cyan' :   chosen = 5;  break;
        case 'White' :  chosen = 6;  break;
        case 'Orange' : chosen = 7;  break;
        case 'Pink' :   chosen = 8;  break;
        case 'Purple' : chosen = 9;  break;
        default :       chosen = -1; break; // should not reach here
    }
    return chosen;
  }

//--------------------------------Disconnection alert---------------------------------//
  Future<void> showAlert(Widget setting, BuildContext context)
  {
      return showDialog<void>(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(Icons.error,size: 70, color: Colors.red,),
            content: Text("Make sure you are connected to device",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 25),
            textAlign: TextAlign.center,),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.
                            copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () => {
                     Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => setting),
                              ),
                  }, 
                  child: const Text("Connect")),
              ),
            ],
          );
        });
  }

//------------------------------Asynchromous Bluetooth Disconnection-------------------------//
Future<void>? asyncAlertBluetooth(Widget setting, BuildContext context)
{
  if(BLE_Connection().esp_device == null)
  {
    BLE_Connection().disconnect();
    return showDialog<void>(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(Icons.error,size: 70, color: Colors.red,),
            content: Text("Your connection might lost,please try to reconnect",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 25),
            textAlign: TextAlign.center,),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.
                            copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () => {
                     Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => setting),
                              ),
                  }, 
                  child: const Text("Connect")),
              ),
            ],
          );
        });
  }
  return null;
}
//---------------------------------Asynchronous ESP-NOW Disconnection--------------------------//
Future<void>? asyncAlertESPNNow(Widget setting, BuildContext context)
{
  if(BLE_Connection().read_value[0] == 200)
  {
    BLE_Connection().disconnect();
    return showDialog<void>(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Icon(Icons.error,size: 70, color: Colors.red,),
            content: Text("One or more of the devices might lost connection, please check the buttons and reconnect",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 25),
            textAlign: TextAlign.center,),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: Theme.of(context).elevatedButtonTheme.style!.
                            copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                  onPressed: () => {
                    BLE_Connection().disconnect(),
                    Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => setting),
                              ),
                  }, 
                  child: const Text("Connect")),
              ),
            ],
          );
        });
  }
  return null;
  
}

//------------------------------Connection Instructions----------------------------//
  Future<void> showConnectionInsr(BuildContext context)
  {
    return showDialog<void>(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(connectTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,),
            content: Text(connectExp,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 15,height: 2),
                      textAlign: TextAlign.left,
                      softWrap: true,),
    
            actions: [
              ElevatedButton(
                onPressed: () => { Navigator.pop(context)}, 
                child: Text("Ok",
                  style:Theme.of(context).textTheme.displayMedium)),
            ],
          );
        });
  }

//----------------------------------Game Explaination Floating Dialog-------------------------------------//

Future<void> gameExp(int state,BuildContext context)
  {
    RichText? richText;
    String title = "";
    switch(state)
    {
      case 1: richText = text1; 
              title = game1_title;
              break;
      case 2: richText = text2; 
              title = game2_title;
              break;
      case 3: richText = text3; 
              title = game3_title;
              break;
      case 4: richText = text4; 
              title = game4_title;
              break;
      case 5: richText = text5;
              title = game5_title;
    }
    return showDialog<void>(
        context: context, 
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title,
                  style: Theme.of(context).textTheme.titleSmall,
                  textAlign: TextAlign.center,),
            content: richText,
            actions: [
              ElevatedButton(
                onPressed: () => { Navigator.pop(context)}, 
                child: Text("Ok",
                  style:Theme.of(context).textTheme.displayMedium)),
            ],
          );
        });
  }

//----------------------------------Colored box for displaying statistics---------------------------------//
Widget displayText(Widget text, int background)
{
  return Container(
    padding: const EdgeInsets.all(15),
    width: 175,
    height: 160,
    decoration: BoxDecoration(
      gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: const Alignment(0.7, 1),
            colors: colorsBackground[background], 
            tileMode: TileMode.mirror,
          ),
      borderRadius: const BorderRadius.all(Radius.circular(20))
    ),
  child: text,
  );
}

//----------------------Background Gradient-------------//
Widget backgroundGradient(Widget body) {
  return Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/background.png"), // Ensure path is correct
        fit: BoxFit.cover, // Ensures the image covers the entire screen
      ),
    ),
    child: body,
  );
}
//-------------------Home Icon-------------------------//

Widget homeIcon(Widget homeScreen, BuildContext context)
{
   return Container(
                    constraints: const BoxConstraints(maxHeight: 65, maxWidth: 40),
                    padding: const EdgeInsets.only(top: 25),
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      iconSize: 40,
                      onPressed: (){
                          Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) => homeScreen),
                                        (route) => false,
                                      );
                          },  
                      icon: const Icon(Icons.home)),
                  );
}
//------------------Init Audio Player---------------------//
Future<void> initAudio() async
{
    //await player.setAsset('assets/sample.mp3');
}

//---------------------------Button Text Display---------------------------//
Widget buttonTextDisplay(Widget text)
{
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: text);
}

//-----------------------------Choosing Game Button With Icon--------------------------//

Widget displayTextAndIcon(int state, BuildContext context, List<double> paddings)
{
  Icon icon = const Icon(Icons.abc);
  String text="";
  switch(state)
  {
    case 1 : icon = const Icon(Icons.fitness_center, size: 50, color: Colors.white,);
             text = game1_name; 
             break;
    case 2 : icon = const Icon(Icons.school, size: 50,color: Colors.white,);
             text = game2_name; 
             break;
    case 3 : icon = const Icon(Icons.people_outline, size: 50,color: Colors.white,);
            text = game3_name; 
             break;
    case 4 : icon = const Icon(Icons.safety_divider, size: 50,color: Colors.white,);
             text = game4_name; 
             break; 
    case 5: icon = const Icon(Icons.directions_run, size: 50, color: Colors.white,);
            text = game5_name;
            break;        
  }

  return Column(children: [
        Padding(
          padding: EdgeInsets.only(top: paddings[0], bottom: paddings[1], right: paddings[2], left: paddings[3]),
          child: Text(text, 
            style: Theme.of(context).textTheme.displaySmall,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: paddings[0], bottom: paddings[1], right: paddings[2], left: paddings[3]),
          child: icon,
        ),
  ],);
}
