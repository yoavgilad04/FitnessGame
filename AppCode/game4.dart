
import 'dart:async';

import 'package:fitnessgame_app/BLE.dart';
import 'package:fitnessgame_app/countdown.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'package:fitnessgame_app/constants.dart';
import 'package:fitnessgame_app/functions.dart';



class Game4Settings extends StatefulWidget{
  final Widget homescreen;
  const Game4Settings({super.key, required this.homescreen});

  @override
  State<Game4Settings> createState() => _Game4SettingsState();
}

class _Game4SettingsState extends State<Game4Settings> {

  final _validateName1 = GlobalKey<FormState>();
  final _validateName2 = GlobalKey<FormState>();
  final _validateTime = GlobalKey<FormState>();

  TextEditingController time_control = TextEditingController();
  TextEditingController name1_control = TextEditingController();
  TextEditingController name2_control = TextEditingController();

   String? dropdownValue1 = "Blue";
   String? dropdownValue2 = "Blue";

  @override
  Widget build(BuildContext context)
  {
      List<String> names;
      int time;
      List<int> colors;

      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: backgroundGradient(Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              homeIcon(widget.homescreen, context),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(game4_name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,),
                      const Spacer(),                  
                      
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                          key: _validateTime,
                          child: SizedBox(
                            width: fieldWidth,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    icon: Icon(Icons.access_time),
                                    labelText: "Game Time(seconds)",
                                    contentPadding: EdgeInsets.all(19),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (String? value) {
                                    
                                      if(value == null || value.isEmpty)
                                      {
                                        return "Requested Field";
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
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _validateName1,
                            child: SizedBox(
                              width: fieldWidth,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.person),
                                  labelText: "Player 1 - Name",
                                  contentPadding: EdgeInsets.all(19),
                                ),
                                validator: (String? value) {
                                  return (value == null || value.isEmpty) ? "Requested Field" : null;
                                } ,
                                controller: name1_control,
                            )
                          ),   
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: fieldWidth , 
                          child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        icon: Icon(Icons.color_lens),
                                        contentPadding: EdgeInsets.all(9),
                                      ),
                              value: dropdownValue1,
                              items: colorstrings2.map(
                                (String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: GradientText(value, 
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          colors: getColor(value)));
                                }).toList(),
                              onChanged: (String? newValue)
                              {
                                  dropdownValue1 = newValue;
                              },
                              validator: (value) =>  dropdownValue1 == dropdownValue2 ?
                                                       "This color is already choosed" : null,
                            ),
                          
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Form(
                            key: _validateName2,
                            child: SizedBox(
                              width: fieldWidth,
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  icon: Icon(Icons.person),
                                  labelText: "Enter Your Name",
                                  contentPadding: EdgeInsets.all(19),
                                ),
                                validator: (String? value) {
                                  return (value == null || value.isEmpty) ? "Requested Field" : null;
                                } ,
                                controller: name2_control,
                            )
                          ),   
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: fieldWidth , 
                          child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        icon: Icon(Icons.color_lens),
                                        contentPadding: EdgeInsets.all(9),
                                      ),
                              value: dropdownValue2,
                              items: colorstrings2.map(
                                (String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: GradientText(value, 
                                          style: Theme.of(context).textTheme.bodyMedium,
                                          colors: getColor(value)));
                                }).toList(),
                              onChanged: (String? newValue)
                              {
                                  dropdownValue2 = newValue;
                              },
                              validator: (value) =>  dropdownValue1 == dropdownValue2 ?
                                                       "This color is already choosed" : null,
                            ),
                          
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [ 
                          const Spacer(),       
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              style: Theme.of(context).elevatedButtonTheme.style!.
                                        copyWith(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 251, 47, 32))),
                              onPressed: () => {
                                Navigator.pop(context)
                              }, 
                              child: buttonTextDisplay(Text("Back",
                                      style: Theme.of(context).textTheme.displayMedium))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                  if(_validateTime.currentState!.validate() &&_validateName1.currentState!.validate() 
                                        && _validateName2.currentState!.validate())//the inputs are fine
                                  {                               
                                          names = [name1_control.text, name2_control.text],
                                          colors = [getColorSerial(dropdownValue1!), getColorSerial(dropdownValue2!)],
                                          time = int.parse(time_control.text),
                                          BLE_Connection().write([4,time, colors[0], colors[1]]),
                                           Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: time,
                                                                    actualTimes:const [],names: names, colors: colors, showStats: false,))),),
                                  }
                              }, 
                              child: buttonTextDisplay(Text("Start",
                                      style: Theme.of(context).textTheme.displayMedium))),
                          ),
                          ],
                        ),
                        const Spacer(),
                    ],
                  ),
                ),
              )
          ])
        ),
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
  Game4Timer({super.key, required this.homescreen, required this.names, required this.time, 
              required this.colors, required this.showStats, required this.actualTimes});
  bool isPaused = false;
  String title = "Game Is On";
  bool waiting = false;

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
            setState(() {
              widget.waiting = true;
            });
            await Future.delayed(const Duration(seconds: 4));
            player.stop();
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
            player.stop();
            Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: widget.time,
                                                                actualTimes: [widget.time], names: widget.names, colors: widget.colors, 
                                                                showStats: true,))));
          }
        }
        else
        {
          if(!widget.isPaused)
          {
            setState(() {
              current_time--;
            });
          }
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
    current_time = widget.time;
    player.seek(const Duration(seconds: 0));
    player.play();
    player.setVolume(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    int actual_time = 0;
    Icon pauseIcon = widget.isPaused ? const Icon(Icons.play_arrow, color: Colors.white,) : const Icon(Icons.pause, color: Colors.white,);
    
    return Scaffold(
      body: backgroundGradient(
         Center(
           child: Column(
            children: [
            const Spacer(),
            Text(widget.title,
              style: Theme.of(context).textTheme.titleLarge,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Time: $current_time",
                style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed:!(widget.waiting) ? () async => {
                actual_time = widget.time - current_time,
                timer.cancel(),
                setState(() => {
                    widget.waiting = true
                  }), 
                if(widget.showStats)
                {
                  BLE_Connection().write([8,1,1,1]),
                  await Future.delayed(const Duration(seconds: 4)),
                  player.stop(),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Game4_Stats(homescreen: widget.homescreen,
                                                              actual_time: [...widget.actualTimes,actual_time]
                                                              , names: widget.names,))),
                }
                else{
                  BLE_Connection().write([8,1,1,1]),
                  player.stop(),
                       Navigator.push(context,MaterialPageRoute(builder: (context) =>  CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: widget.time,
                                                                  actualTimes: [actual_time],names: widget.names, 
                                                                  colors: widget.colors, showStats: true,))))
                }
              } : null, 
              child: buttonTextDisplay(Text("Finish",
                style: Theme.of(context).textTheme.displayMedium))
              ),
              Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed:!(widget.waiting) ? () => {
                      widget.isPaused = !widget.isPaused,
                      widget.isPaused ? BLE_Connection().write([6]) : BLE_Connection().write([4]),
                      widget.isPaused ? player.pause() : player.play(),
                      setState(() => {
                        widget.title = widget.isPaused ? "Paused!" : "Game Is On"
                      }),
                } : null, 
                child: buttonTextDisplay(pauseIcon),                
                ),
            ),
            const Spacer(),
                 ]),
         ),
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

  List<Widget> displayTime(int time1, int time2, BuildContext context, String n1, String n2, List<int> backgrounds)
  {
    List<Widget> res = [];
    if(time1 == time2)
    {
      res = [
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      const Icon(Icons.timer, size: 70),
                      Text("$time1 seconds",style: Theme.of(context).textTheme.bodyMedium,)
                  ],),4
              ),
          const Spacer(),
      ];
    }
    else
    {
      res = [
          Row(children: [
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("$n1 played:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$time1 seconds",style: Theme.of(context).textTheme.bodyMedium,)
                  ],),backgrounds[0]
              ),
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("$n2 played:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$time2 seconds",style: Theme.of(context).textTheme.bodyMedium,)
                  ],),backgrounds[1]
              ),
          const Spacer(),
        ],),
      ];
    }
    return res;
  }

  List<Widget> chooseWinner(BuildContext context, List<String> n, int clicks1, int clicks2,int time1, int time2)
  {
    List<Widget> result;
    if(clicks1 != clicks2)
    {
      bool firstWinner = clicks1 > clicks2;
      String winner = firstWinner ? n[0] : n[1];
      String looser = firstWinner ? n[1] : n[0];
      int winnerClicks = firstWinner ? clicks1 : clicks2;
      int looserClicks = firstWinner ? clicks2 : clicks1;
      int timeWinner = firstWinner ? time1 : time2;
      int timeLooser = firstWinner ? time2 : time1;
      double avgWinner = winnerClicks.toDouble()/timeWinner;
      double avgLooser = looserClicks.toDouble()/timeLooser;
      String avgRoundedWinner = avgWinner.toStringAsFixed(5);
      String avgRoundedLooser = avgLooser.toStringAsFixed(5);
      List<Widget> timeDisplay = displayTime(timeWinner, timeLooser, context, winner, looser,[3,4]); 
      result = [
         Row(children: [
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      const Icon(Icons.emoji_events, size: 70),
                      Text(winner,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      const Icon(Icons.sentiment_very_dissatisfied, size: 70),
                      Text(looser,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
              ),
          const Spacer(),
        ],),
        const Spacer(),
        Row(children: [
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Number of Clicks:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$winnerClicks",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Number of Clicks:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$looserClicks",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
              ),
          const Spacer(),
        ],),
        const Spacer(),
        Row(children: [
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Clicks per second:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text(avgRoundedWinner,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Clicks per second:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text(avgRoundedLooser,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
          ),
          const Spacer(),
        ],),
        const Spacer(),
        ...timeDisplay,
          const Spacer(),
        
      ];
    }
    else
    {
      double avgBoth = clicks1.toDouble()/time1;
      String avgRounded = avgBoth.toStringAsFixed(5);
      List<Widget> timeDisplay = displayTime(time1, time2, context, n[0], n[1], [4,4]); 
      result = [
         displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Tie!!!",style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
                  ],),4
              ),
        const Spacer(),
         displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Number of Clicks:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$clicks1",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
              ),
          const Spacer(),
         displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Clicks per second:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text(avgRounded,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
              ),
          const Spacer(),
          ...timeDisplay,
          const Spacer(),
      ];
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
      backgroundGradient(  
               Column(
              children: [
                const Spacer(),       
                ...display,
                const Spacer(),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(builder: (context) => homescreen),
                                            (route) => false,
                                          )
                  }, 
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buttonTextDisplay(Text("Let's Play Again",
                                  style: Theme.of(context).textTheme.displayMedium)),
                  )),
                const Spacer(),
                   ]),
      ),);
  }
}