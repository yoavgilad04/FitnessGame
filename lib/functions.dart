
import 'package:flutter/material.dart';

var colorstrings = <String>['Random', 'Blue','Orange','Purple','Brown','Pink',"Cyan","White"];
var colorstrings2 = <String>['Blue','Orange','Purple','Brown','Pink',"Cyan","White"];
var rainbowColors = <Color>[Colors.blue,Colors.red,Colors.green,Colors.yellow,Colors.purple];

List<Color> getColor(String value)
  {
    List<Color> chosen = [Colors.amber, Colors.amber];
    switch(value) 
    {
        case 'Blue' : chosen = [const Color.fromARGB(255, 21, 0, 212), Colors.blue]; break;
        case 'Orange' : chosen = [Colors.orange, const Color.fromARGB(255, 252, 190, 97)]; break;
        case 'Purple' : chosen = [Colors.purple, const Color.fromARGB(255, 188, 114, 201)]; break;
        case 'Brown' : chosen = [Colors.brown, const Color.fromARGB(255, 187, 144, 127)]; break;
        case 'Pink' : chosen = [Colors.pink, const Color.fromARGB(255, 251, 117, 161)]; break;
        case 'Cyan' : chosen = [Colors.cyan, Colors.cyanAccent]; break;
        case 'White' : chosen = [ const Color.fromARGB(255, 249, 107, 107), const Color.fromARGB(255, 247, 184, 184)]; break;
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
        case 'Blue' : chosen = 3; break;
        case 'Orange' : chosen = 7; break;
        case 'Purple' : chosen = 9; break;
        case 'Brown' : chosen = 4; break;
        case 'Pink' : chosen = 8; break;
        case 'Cyan' : chosen = 5; break; 
        case 'White' : chosen = 6; break; 
        case 'Random' : chosen = 0; break;
        default : chosen = -1;
    }
    return chosen;
  }

  Future<void> showAlert(Widget setting,Widget gameChoosing, BuildContext context) async
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
              ElevatedButton(
                style: Theme.of(context).elevatedButtonTheme.style!.
                          copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.grey)),
                onPressed: () => {
                   Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => setting),
                            ),
                }, 
                child: const Text("Connect")),
            ],
          );
        });
  }
  
  