
import 'dart:async';

import 'package:fitnessgame_app/BLE.dart';
import 'package:fitnessgame_app/countdown.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'functions.dart';




class Game4Start extends StatelessWidget{
  final Widget homescreen;
  const Game4Start({super.key, required this.homescreen});

  final String exp = '''Rules of the Game :
  Players will play the same game 
  one after the other, i.e.
  separately.
  Number of players: 2
  0<=Time<=120 seconds
 ''';
  
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
                      Text("Push The \nLights 1v1 -\n Explanation:",
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
                                            MaterialPageRoute(builder: (context) => Game4Settings(homescreen: homescreen,names: const [],
                                                                      time: 0,colors: const [],playing: false,)),
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


class Game4Settings extends StatefulWidget{
  List<String> names;
  final int time;
  List<int> colors;
  final bool playing;
  final Widget homescreen;
  Game4Settings({super.key, required this.homescreen, required this.names, 
                  required this.colors, required this.playing, required this.time});

  @override
  State<Game4Settings> createState() => _Game4SettingsState();
}

class _Game4SettingsState extends State<Game4Settings> {

  final _validateName = GlobalKey<FormState>();
  final _validateTime = GlobalKey<FormState>();
  final _validateColor = GlobalKey<FormState>();

  TextEditingController time_control = TextEditingController();
  TextEditingController name_control = TextEditingController();

   String? dropdownValue = "Blue";

  @override
  Widget build(BuildContext context)
  {
      int time_chosen;
      int color_chosen;
      String name_chosen;
      List<String> n = widget.names;
      List<int> c = widget.colors;
      String s = !(widget.playing) ? "Player 1" : "Player 2";
      bool isValidateTime;

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
                  Text("Define Your\n Game -\n $s: ",
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
                    child: !(widget.playing) ? Form(
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
                    ) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      width: 250 , 
                      child: Form(
                        key: _validateColor,
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
                          },
                          validator: (value) =>  c.isNotEmpty && c[0] == getColorSerial(value!) ?
                                                   "This color is already choosed" : null,
                        ),
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
                            if(widget.names.isNotEmpty)
                            {
                                widget.names.removeLast(),
                                widget.colors.removeLast(),
                            },
                            Navigator.pop(context)
                          }, 
                          child: Text("Back",
                                  style: Theme.of(context).textTheme.bodyMedium)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () => {
                              isValidateTime = !(widget.playing) ? _validateTime.currentState!.validate() : true, 
                              if(_validateName.currentState!.validate() && isValidateTime && _validateColor.currentState!.validate())//the inputs are fine
                              {                               
                                  
                                    name_chosen = name_control.text,
                                    color_chosen = getColorSerial(dropdownValue!),

                                    c = [...c,color_chosen],
                                    n = [...n,name_chosen],
                                    if(widget.playing)
                                    {
                                       Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: widget.time,
                                                                actualTimes:const [],names: n, colors: c, showStats: false,))),),
                                    }
                                    else
                                    {
                                      time_chosen = int.parse(time_control.text),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Game4Settings(homescreen: widget.homescreen,
                                                        names: n, time: time_chosen ,colors: c,playing: true,)),),
                                    }
                              }
                          }, 
                          child: Text(!(widget.playing) ? "Next" : "Start",
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

class Game4Timer extends StatefulWidget
{
  final Widget homescreen;
  final List<String> names;
  final int time;
  final List<int> actualTimes;
  final List<int> colors;
  final bool showStats;
  const Game4Timer({super.key, required this.homescreen, required this.names, required this.time, 
              required this.colors, required this.showStats, required this.actualTimes});

  @override
  State<Game4Timer> createState() => _Game4TimerState();
}

class _Game4TimerState extends State<Game4Timer> {
  late Timer timer;
  int current_time = 0;

  void setCountDown()
  {
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) async{
        if(current_time == 0)
        {
          timer.cancel();
          if(widget.showStats)
          {
            await Future.delayed(const Duration(seconds: 4));
            if(context.mounted)
            {
            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Game4_Stats(homescreen: widget.homescreen,
                                                            actual_time: [...widget.actualTimes,widget.time]
                                                            , names: widget.names,)));
            }
          }
          else
          {
            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: widget.time,
                                                                actualTimes: [widget.time], names: widget.names, colors: widget.colors, 
                                                                showStats: true,))));
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
    if(!widget.showStats)
    {
      BLE_Connection().write([4,widget.time,widget.colors[0],widget.colors[1]]);
    }
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
              await BLE_Connection().write([7]),
              if(widget.showStats)
              { 
                await Future.delayed(const Duration(milliseconds: 500)),
                Navigator.push(context, MaterialPageRoute(builder: (context) => Game4_Stats(homescreen: widget.homescreen,
                                                            actual_time: [...widget.actualTimes,actual_time]
                                                            , names: widget.names,))),
              }
              else{
                    MaterialPageRoute(builder: (context) =>  CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: actual_time,
                                                                actualTimes: [actual_time],names: widget.names, 
                                                                colors: widget.colors, showStats: true,)))
              }
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

class Game4_Stats extends StatelessWidget
{
  final Widget homescreen;
  final List<int> actual_time;
  final List<String> names;
  const Game4_Stats({super.key, required this.actual_time, required this.homescreen, required this.names});

  List<Widget> displayTime(int time1, int time2, BuildContext context)
  {
    List<Widget> res = [];
    if(time1 == time2)
    {
      res = [
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Each Player played $time1 seconds",
              softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
      ];
    }
    else
    {
      res = [
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Player 1 played $time1 seconds",
              softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Player 2 played $time2 seconds",
              softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
      ];
    }
    return res;
  }

  List<Widget> chooseWinner(BuildContext context, List<String> n, int clicks1, int clicks2,int time1, int time2)
  {
    List<Widget> result;
    List<Widget> timeDisplay = displayTime(time1, time2, context);
    if(clicks1 != clicks2)
    {
      bool firstWinner = clicks1 > clicks2;
      String winner = firstWinner ? n[0] : n[1];
      String looser = firstWinner ? n[1] : n[0];
      int winnerClicks = firstWinner ? clicks1 : clicks2;
      int looserClicks = firstWinner ? clicks2 : clicks1;
      result = [
        ...timeDisplay,
        Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("The Winner is:   $winner",
              softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("An impresive number of clicks:   $winnerClicks",
              softWrap: true,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("The one who need to practice:   $looser",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text("Number of clicks:   $looserClicks",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                )
              ),
            ),
        
      ];
    }
    else
    {
      result = [Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Tie!",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 45,
                  background: Paint()
                  ..strokeWidth = 61
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                ),
                ),
            ),
            const Spacer(),
            ...timeDisplay,
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text("Number of clicks: $clicks1",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontSize: 20,
                  background: Paint()
                  ..strokeWidth = 45
                  ..color = Colors.blueAccent
                  ..style = PaintingStyle.stroke
                  ..strokeJoin = StrokeJoin.round
                ),
                ),
            ),];
    }
    return result;
  }


  @override
  Widget build(BuildContext context) {
    int time1 = actual_time[0];
    int time2 = actual_time[1];
    int first_clicks = BLE_Connection().read_value[0];
    int second_clicks = BLE_Connection().read_value[1];
    List<Widget> display = chooseWinner(context,names,first_clicks,second_clicks, time1, time2);
    return Scaffold(body: 
      Center(
        child: Column(
          children: [
            const Spacer(),
            Text("Final Results: ",
              style: Theme.of(context).textTheme.titleLarge,),
            const Spacer(),
            ...display,
            const Spacer(),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => homescreen)),
              }, 
              child: Text("Let's Play Again",
                            style: Theme.of(context).textTheme.bodyMedium,)),
            const Spacer(),
        ]),
      ),);
  }
}