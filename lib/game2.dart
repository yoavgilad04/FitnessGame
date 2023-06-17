
import 'dart:async';

import 'package:fitnessgame_app/BLE.dart';
import 'package:fitnessgame_app/countdown.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'functions.dart';




class Game2Start extends StatelessWidget{
  final Widget homescreen;
  const Game2Start({super.key, required this.homescreen});

  final String exp = '''Rules of the Game :
  The player will choose a single 
  color on which the player will
  have to click. During the passing 
  time, several colors will light up
  and the player must click only on
  the color he chose.
  If he clicks on the wrong color,
  he will get a bad score
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
                      Text("Hit The Color -\n Explanation:",
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
                                            MaterialPageRoute(builder: (context) => Game2Settings(homescreen: homescreen)),
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


class Game2Settings extends StatefulWidget{
  final Widget homescreen;
  const Game2Settings({super.key, required this.homescreen});

  @override
  State<Game2Settings> createState() => _Game2SettingsState();
}

class _Game2SettingsState extends State<Game2Settings> {

  final _validateName = GlobalKey<FormState>();
  final _validateTime = GlobalKey<FormState>();
  TextEditingController time_control = TextEditingController();
  TextEditingController name_control = TextEditingController();

   String? dropdownValue = "Blue";


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
                        items: colorstrings2.map(
                          (String value) {
                            return DropdownMenuItem(
                              value: value,
                              child: GradientText(value, 
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20.0),
                                    colors: getColor(value)));
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
                                  color_chosen = getColorSerial(dropdownValue!),
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CountDown(nextScreen: Game2Timer(homescreen: widget.homescreen,time: time_chosen, color: color_chosen))),
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

class Game2Timer extends StatefulWidget
{
  final Widget homescreen;
  int time;
  int color;
  Game2Timer({super.key, required this.homescreen, required this.time, required this.color});

  @override
  State<Game2Timer> createState() => _Game2TimerState();
}

class _Game2TimerState extends State<Game2Timer> {
  late Timer timer;
  int current_time = 0;

  void setCountDown()
  {
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) async {
        if(current_time == 0)
        {
          timer.cancel();
          await Future.delayed(const Duration(seconds: 4));
          if(context.mounted)
          {
            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Game2_Stats(actual_time: widget.time,homescreen: widget.homescreen,)));
          }
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
    BLE_Connection().write([2,widget.time,widget.color]);
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
            onPressed: () async => {
              actual_time = widget.time - current_time,
              timer.cancel(),
              await Future.delayed(const Duration(seconds: 4)),
              Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Game2_Stats(actual_time: actual_time,homescreen: widget.homescreen,))),
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

class Game2_Stats extends StatelessWidget
{
  final Widget homescreen;
  final int actual_time;
  const Game2_Stats({super.key, required this.actual_time, required this.homescreen});

  @override
  Widget build(BuildContext context) {
    int total_time = actual_time;
    int right_clicks = BLE_Connection().read_value[0];
    int wrong_clicks = BLE_Connection().read_value[1];
    return Scaffold(body: 
      Center(
        child: Column(
          children: [
            const Spacer(),
            Text("Final Results: ",
              style: Theme.of(context).textTheme.titleLarge,),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Total game time: $total_time",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 27,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                ),
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("You were focused: $right_clicks",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 27,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("You need glasses $wrong_clicks times",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 27,
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