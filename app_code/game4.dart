
import 'dart:async';

import 'BLE.dart';
import 'countdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import 'constants.dart';
import 'functions.dart';

import 'Setting.dart';

//----------------------------------------------------------------------------------------------------------//
//---------------------------------------Choosing Game Details----------------------------------------------//
//----------------------------------------------------------------------------------------------------------//

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

// game 4 - can't have random color(need to display the winner on the buttons)
// colors can be the same
   String? dropdownValue1 = "Blue";
   String? dropdownValue2 = "Blue";

  @override
  Widget build(BuildContext context)
  {
    //-----------------------------------------Listen for Disconnection------------------------------------------//
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(ConnectPage(homescreen: widget.homescreen), context);
      asyncAlertESPNNow( ConnectPage(homescreen: widget.homescreen), context);
    });
//----------------------------------------------------------------------------------------------------------//
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
//---------------------------------------------Game Title----------------------------------------------//
                      Text(game4_name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,),
                      const Spacer(),                  
//---------------------------------------------Game Time----------------------------------------------//
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
                                    fillColor: Color.fromARGB(255, 12, 65, 210),
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
//-----------------------------------------Player 1 Name-------------------------------------------//
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
                                  fillColor: Color.fromARGB(255, 12, 65, 210),
                                ),
                                validator: (String? value) {
                                  return (value == null || value.isEmpty) ? "Requested Field" : null;
                                } ,
                                controller: name1_control,
                            )
                          ),   
                        ),
                      ),
//--------------------------------------------Player 1 Color(Default = Blue)--------------------------------------------//
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: fieldWidth , 
                          child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        icon: Icon(Icons.color_lens),
                                        contentPadding: EdgeInsets.all(9),
                                        fillColor: Color.fromARGB(255, 12, 65, 210),
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
//-----------------------------------------------Player 2 Name--------------------------------------------------//
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
                                  labelText: "Player 2 - Name",
                                  contentPadding: EdgeInsets.all(19),
                                  fillColor: Color.fromARGB(255, 12, 65, 210),
                                ),
                                validator: (String? value) {
                                  return (value == null || value.isEmpty) ? "Requested Field" : null;
                                } ,
                                controller: name2_control,
                            )
                          ),   
                        ),
                      ),
//---------------------------------------------Player 2 Color(Default = Blue)-------------------------------------//
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: fieldWidth , 
                          child: DropdownButtonFormField(
                              decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        icon: Icon(Icons.color_lens),
                                        contentPadding: EdgeInsets.all(9),
                                        fillColor: Color.fromARGB(255, 12, 65, 210),
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
//--------------------------------------------------Go Back to Choosing Game------------------------------------------------//       
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
//-----------------------------------------------------Start Game---------------------------------------------------//
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                  if(_validateTime.currentState!.validate() &&_validateName1.currentState!.validate() 
                                        && _validateName2.currentState!.validate())
                                  {                               
//-----------------------------------------Values are Fine, Moving Forward-------------------------------------------//
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

//----------------------------------------------------------------------------------------------------------//
//----------------------------------------------Game Timer--------------------------------------------------//
//----------------------------------------------------------------------------------------------------------//

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
  
  // at the begining, the game is running
  bool isPaused = false;
  String title = "Game Is On";

  //if the game is ended/finished, 'wating' disables pushing buttons
  bool waiting = false;

  @override
  State<Game4Timer> createState() => _Game4TimerState();
}

class _Game4TimerState extends State<Game4Timer> {
  late Timer timer;
  int current_time = 0;

//---------------------------------------------Activate Timer-----------------------------------------------------//
  void setCountDown()
  {
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) async{
        if(current_time == 0)
        {
          stopBackgroundMusic(gameMusicPlayer);
          timer.cancel();
          if(widget.showStats)
          {
            setState(() {
              widget.waiting = true;
            });
            await Future.delayed(const Duration(seconds: 4));
            //player.stop();
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
            //player.stop();
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
    stopBackgroundMusic(bgMusicPlayer);
    setCountDown();
    current_time = widget.time;
    // player.seek(const Duration(seconds: 0));
    // player.play();
    // player.setVolume(1);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //-----------------------------------------Listen for Disconnection------------------------------------------//
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(ConnectPage(homescreen: widget.homescreen), context);
      asyncAlertESPNNow( ConnectPage(homescreen: widget.homescreen), context);
    });
//----------------------------------------------------------------------------------------------------------//
    int actualTime = 0;
    Icon pauseIcon = widget.isPaused ? const Icon(Icons.play_arrow, color: Colors.white,) : const Icon(Icons.pause, color: Colors.white,);
    
    return Scaffold(
      body: backgroundGradient(
         Center(
           child: Column(
            children: [
            const Spacer(),
            Text(widget.title,
              style: Theme.of(context).textTheme.titleLarge,),
//---------------------------------------------Current Time Title----------------------------------------------//
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Time: $current_time",
                style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Spacer(),
//----------------------------------------------Finish Button---------------------------------------------------//
            ElevatedButton(
              onPressed:!(widget.waiting) ? () async => {
                actualTime = widget.time - current_time,
                timer.cancel(),
                setState(() => widget.waiting = true
                  ), 
                if(widget.showStats)
                {
//---------------------------------------Player 2 finish => Move to Show Statistics------------------------------//
                  BLE_Connection().write([8,1,1,1]),
                  await Future.delayed(const Duration(seconds: 4)),
                  //player.stop(),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Game4_Stats(homescreen: widget.homescreen,
                                                              actual_time: [...widget.actualTimes,actualTime]
                                                              , names: widget.names,))),
                }
                else{
//---------------------------------------Player 1 finish => Move to The Next One---------------------------------//
                  BLE_Connection().write([8,1,1,1]),
                  //player.stop(),
                       Navigator.push(context,MaterialPageRoute(builder: (context) =>  CountDown(nextScreen: Game4Timer(homescreen: widget.homescreen,time: widget.time,
                                                                  actualTimes: [actualTime],names: widget.names, 
                                                                  colors: widget.colors, showStats: true,))))
                }
              } : null, 
              child: buttonTextDisplay(Text("Finish",
                style: Theme.of(context).textTheme.displayMedium))
              ),
//------------------------------------------------Pause Button--------------------------------------------------//
              Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed:!(widget.waiting) ? () => {
                      widget.isPaused = !widget.isPaused,
                      widget.isPaused ? BLE_Connection().write([6]) : BLE_Connection().write([4]),
                      //widget.isPaused ? player.pause() : player.play(),
                      setState(() => widget.title = widget.isPaused ? "Paused!" : "Game Is On"
                      ),
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


//------------------------------------------------------------------------------------------------------------//
//---------------------------------------Game Statistics Display----------------------------------------------//
//------------------------------------------------------------------------------------------------------------//

class Game4_Stats extends StatelessWidget
{
  final Widget homescreen;
  final List<int> actual_time;
  final List<String> names;
  const Game4_Stats({super.key, required this.actual_time, required this.homescreen, required this.names});

//----------------------------------------Display Time Played--------------------------------------------------------//
  List<Widget> displayTime(int time1, int time2, BuildContext context, String n1, String n2, List<int> backgrounds)
  {
    List<Widget> res = [];
    if(time1 == time2)
    {
//------------------------------------Both Players play for The Same Time--------------------------------------------//
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
//-----------------------------------Each Player plays for Different Time--------------------------------------------//
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

//-----------------------------------------Display Players Statistics-----------------------------------------------//
  List<Widget> chooseWinner(BuildContext context, List<String> n, int clicks1, int clicks2,int time1, int time2)
  {
    List<Widget> result;
    if(clicks1 != clicks2)
    {
//------------------------------------------Check Who Wins and Classify Data-------------------------------------//
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
//---------------------------------------------Display Time-----------------------------------------------------//
      List<Widget> timeDisplay = displayTime(timeWinner, timeLooser, context, winner, looser,[3,4]); 
      result = [
         Row(children: [
          const Spacer(),
//---------------------------------------------Winner Icon-----------------------------------------------------//
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      const Icon(Icons.emoji_events, size: 70),
                      Text(winner,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
//--------------------------------------------Looser Icon------------------------------------------------------//
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
//--------------------------------------Winner Clicks Number---------------------------------------------------//
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Number of Clicks:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$winnerClicks",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
//---------------------------------------Looser Clicks Number--------------------------------------------------//
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
//-------------------------------------Winner Clicks per Second-----------------------------------------------//
          displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Clicks per second:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text(avgRoundedWinner,style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),3
              ),
          const Spacer(),
//-----------------------------------Looser Clicks per Second--------------------------------------------------//
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
//--------------------------------------------Tie------------------------------------------------------//
      double avgBoth = clicks1.toDouble()/time1;
      String avgRounded = avgBoth.toStringAsFixed(5);
//------------------------------------------Display Time-----------------------------------------------//
      List<Widget> timeDisplay = displayTime(time1, time2, context, n[0], n[1], [4,4]); 
      result = [
//-------------------------------------------Tie Title-------------------------------------------------//
         displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Tie!!!",style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
                  ],),4
              ),
        const Spacer(),
//------------------------------------------Clicks Number-----------------------------------------------//
         displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Number of Clicks:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text("$clicks1",style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
                  ],),4
              ),
          const Spacer(),
//----------------------------------------Clicks per Second----------------------------------------------//
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
      ];
    }

    return result;
  }


  @override
  Widget build(BuildContext context) {
    //-----------------------------------------Listen for Disconnection------------------------------------------//
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(ConnectPage(homescreen: homescreen), context);
      asyncAlertESPNNow( ConnectPage(homescreen: homescreen), context);
    });
//----------------------------------------------------------------------------------------------------------//
//-----------------------------------Collecing Statistics Data--------------------------------------------//
    int time1 = actual_time[0];
    int time2 = actual_time[1];
    int firstClicks = BLE_Connection().read_value[0];
    int secondClicks = BLE_Connection().read_value[1];
//-----------------------------------Decide Winner & Looser / Tie-----------------------------------------//
    List<Widget> display = chooseWinner(context,names,firstClicks,secondClicks, time1, time2);
    return Scaffold(body: 
      backgroundGradient(  
               Center(
                 child: Column(
                             children: [
                  const Spacer(),       
                  ...display,
                  const Spacer(),
               //----------------------------------Go Back to MyHomePage-------------------------------------------------//
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
               ),
      ),);
  }
}