
import 'dart:async';
import 'dart:math';

import 'package:fitnessgame_app/BLE.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


var colorstrings = <String>['Random', 'Blue','Yellow','Orange','Purple','Brown','Pink'];


class Game1Start extends StatelessWidget{
  final Widget homescreen;
  const Game1Start({super.key, required this.homescreen});

  final String exp = '''Rules of the Game :
  You have to press the button
  where the light turns on, and only on it.
  After pressing the button, you will earn a 
  noraml press and the light will turn on in
  one of the buttons randomly, until
  the time runs out.
  Number Of Players : 1
  Time <= 120 seconds''';
  
  @override
  Widget build(BuildContext context)
  {
    
      return Scaffold(
        body: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:  
                  Container(
                    constraints: const BoxConstraints(maxHeight: 50, maxWidth: 50),
                    child: IconButton(
                      iconSize: 50,
                      onPressed: (){
                          Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => homescreen),
                                      );
                          },  
                      icon: const Icon(Icons.home)),
                  )
              ),
              Align(
                alignment: Alignment.center,
                child:   Column(
                    mainAxisSize: MainAxisSize.min,
                      children: [
                      const Spacer(),
                      Text("Push The Light -\n Explanation:",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 40),
                        textAlign: TextAlign.center,),
                      const Spacer(),
                      Text(exp,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 2),
                            softWrap: true,
                            textAlign: TextAlign.left,),
                      const Spacer(),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style!.
                                      copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              child:  Text("Back",
                                    style: Theme.of(context).textTheme.bodyMedium)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => Game1Settings(homescreen: homescreen)),
                                          );
                            }, 
                            child: Text("Define your\n Game",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    textAlign: TextAlign.center,)),
                        ],
                      ),
                      const Spacer()
                  ],)
              )
          ,

        ]),
      );
  }
}


class Game1Settings extends StatefulWidget{
  final Widget homescreen;
  const Game1Settings({super.key, required this.homescreen});

  @override
  State<Game1Settings> createState() => _Game1SettingsState();
}

class _Game1SettingsState extends State<Game1Settings> {

  final _validateName = GlobalKey<FormState>();
  final _validateTime = GlobalKey<FormState>();
  TextEditingController time_control = TextEditingController();
  TextEditingController name_control = TextEditingController();

  //LightColor dropdownValue = LightColor.random;
   String? dropdownValue = "Random";

Color getColor(String value)
  {
    Color chosen = Colors.amber;
    switch(value) 
    {
        case 'Blue' : chosen = Colors.blue; break;
        case 'Yellow' : chosen = Colors.yellow; break;
        case 'Orange' : chosen = Colors.orange; break;
        case 'Purple' : chosen = Colors.purple; break;
        case 'Brown' : chosen = Colors.brown; break;
        case 'Pink' : chosen = Colors.pinkAccent; break;
        case 'Random' : chosen = Colors.grey; break;
        default : Colors.amber;
    }
    return chosen;
  }

  int getColorSerial()
  {
    int chosen = 0;
    switch(dropdownValue) 
    {
        case 'Blue' : chosen = 1; break;
        case 'Yellow' : chosen = 2; break;
        case 'Orange' : chosen = 3; break;
        case 'Purple' : chosen = 4; break;
        case 'Brown' : chosen = 5; break;
        case 'Pink' : chosen = 6; break;
        case 'Random' : chosen = 0; break;
        default : Colors.amber;
    }
    return chosen;
  }

  @override
  Widget build(BuildContext context)
  {
      int time_chosen;
      int color_chosen;  
      return Scaffold(
        body: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:  
                  Container(
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),                  
                  Text("Define Your\n Game: ",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,),
                  const Spacer(),                  
                  Form(
                      key: _validateName,
                      child: SizedBox(
                        width: 250,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            icon: Icon(Icons.person),
                            labelText: "Enter Your Name"
                          ),
                          validator: (String? value) {
                            return (value == null || value.isEmpty) ? "Please enter a name" : null;
                          } ,
                          controller: name_control,
                      )
                    ),   
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _validateTime,
                      child: SizedBox(
                        width: 250,
                        child: TextFormField(
                          decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.access_time),
                                labelText: "Time(seconds)"
                              ),
                              keyboardType: TextInputType.number,
                              validator: (String? value) {
                                
                                  if(value == null || value.isEmpty)
                                  {
                                    return "Please enter a number";
                                  }
                                  int num = int.parse(value);
                                  return (num < 0 || num > 120) ? "0<=Time<=120" : null;
                              } ,
                              controller: time_control,
                        ),
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 250 , 
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.color_lens),
                                ),
                        value: dropdownValue,
                        items: colorstrings.map(
                          (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value, 
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: getColor(value),fontSize: 20.0)));
                          }).toList(),
                        onChanged: (String? newValue)
                        {
                            dropdownValue = newValue;
                        }
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [        
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          style: Theme.of(context).elevatedButtonTheme.style!.
                                    copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                          onPressed: () => {
                            Navigator.pop(context)
                          }, 
                          child: Text("Back",
                                  style: Theme.of(context).textTheme.bodyMedium)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () => {
                              if(_validateName.currentState!.validate() && _validateTime.currentState!.validate())//the inputs are fine
                              {
                                  time_chosen = int.parse(time_control.text),
                                  color_chosen = getColorSerial(),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => GameTimer(homescreen: widget.homescreen,time: time_chosen, color: color_chosen)),
                           )
                              }
                          }, 
                          child: Text("Start",
                                  style: Theme.of(context).textTheme.bodyMedium)),
                      ),
                      ],
                    ),
                    const Spacer(),
                ],
              )
        ]),
      );
  }
}

class GameTimer extends StatefulWidget
{
  final Widget homescreen;
  int time;
  int color;
  GameTimer({super.key, required this.homescreen, required this.time, required this.color});

  @override
  State<GameTimer> createState() => _GameTimerState();
}

class _GameTimerState extends State<GameTimer> {
  late Timer timer;
  int current_time = 0;

  void setCountDown()
  {
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) {
        if(current_time == 0)
        {
          Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Game1_Stats(actual_time: widget.time,homescreen: widget.homescreen,)));
          timer.cancel();

        }
        else
        {
          setState(() {
            current_time--;
          });
        }
     });
  }

  @override
  void dispose()
  {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState()
  {
    setCountDown();
    BLE_Connection().write([1,widget.time,widget.color]);
    current_time = widget.time;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int actual_time = 0;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
          const Spacer(),
          Text("Game Is On",
            style: Theme.of(context).textTheme.titleLarge,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Time: $current_time",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black)),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => {
              actual_time = widget.time - current_time,
              Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Game1_Stats(actual_time: actual_time,homescreen: widget.homescreen,))),
            }, 
            child: Text("Finish",
              style: Theme.of(context).textTheme.bodyMedium,)
            ),
          const Spacer(),
        ]),
      ),
    );
  }
}

class Game1_Stats extends StatelessWidget
{
  final Widget homescreen;
  final int actual_time;
  const Game1_Stats({super.key, required this.actual_time, required this.homescreen});

  @override
  Widget build(BuildContext context) {
    int total_time = actual_time;
    int clicks = BLE_Connection().read_value[0];
    return Scaffold(body: 
      Center(
        child: Column(
          children: [
            const Spacer(),
            Text("Final Results: ",
              style: Theme.of(context).textTheme.titleLarge,),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Total game time: $total_time",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: Text("Total clicks: $clicks",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => homescreen)),
              }, 
              child: Text("Let's Play Again",
                            style: Theme.of(context).textTheme.bodyMedium,)),
            const Spacer(),
        ]),
      ),);
  }
}