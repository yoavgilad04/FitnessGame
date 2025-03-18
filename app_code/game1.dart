
import 'dart:async';

import 'BLE.dart';
import 'countdown.dart';
import 'game5.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


import 'constants.dart';
import 'functions.dart';

import 'Setting.dart';

//----------------------------------------------------------------------------------------------------------//
//---------------------------------------Choosing Game Details----------------------------------------------//
//----------------------------------------------------------------------------------------------------------//

class Game1Settings extends StatefulWidget{
  final int gameState;
  final Widget homescreen;
  const Game1Settings({super.key, required this.homescreen, required this.gameState});

  @override
  State<Game1Settings> createState() => _Game1SettingsState();
}

class _Game1SettingsState extends State<Game1Settings> {

  final _validateName = GlobalKey<FormState>();
  final _validateTime = GlobalKey<FormState>();
  TextEditingController time_control = TextEditingController();
  TextEditingController name_control = TextEditingController();

   String? dropdownValue = "Random";



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
      int timeChosen;
      int colorChosen;  
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
//------------------------------------Game Name--------------------------------------//
                      Text((widget.gameState == 1) ? game1_name : game5_name,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,),
                      const Spacer(),
//------------------------------------Player's Name-------------------------------------//                  
                      Form(
                          key: _validateName,
                          child: SizedBox(
                            width: fieldWidth,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                icon: Icon(Icons.person),
                                labelText: "Enter Your Name",
                                contentPadding: EdgeInsets.all(19),
                                fillColor: Color.fromARGB(255, 0, 54, 169)
                              ),
                              validator: (String? value) {
                                return (value == null || value.isEmpty) ? "Requested Field" : null;
                              } ,
                              controller: name_control,
                          )
                        ),   
                      ),
//----------------------------------------Game Time---------------------------------------//
                      Padding(
                        padding: const EdgeInsets.all(20.0),
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
                                    fillColor: Color.fromARGB(255, 0, 54, 169)
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
//----------------------------------------------Choosing Color-----------------------------------------//
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          width: fieldWidth , 
                          child: DropdownButtonFormField(
                            decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      icon: Icon(Icons.color_lens),
                                      contentPadding: EdgeInsets.all(9),
                                      fillColor: Color.fromARGB(255, 0, 54, 169)
                                    ),
                            value: dropdownValue,
                            items: colorstrings.map(
                              (String value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: GradientText(value, 
                                        style: Theme.of(context).textTheme.bodyMedium,
                                        colors: getColor(value),));
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
                          const Spacer(),
//------------------------------------------------Go Back to Choosing Game------------------------------------//       
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                               style: Theme.of(context).elevatedButtonTheme.style!.
                                         copyWith(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 251, 47, 32))),
                              onPressed: () => {
                                Navigator.pop(context)
                              }, 
                              child: buttonTextDisplay(Text("Back",
                                        style: Theme.of(context).textTheme.displayMedium)),
                              )),
//------------------------------------------------------Start Game------------------------------------------------------------//
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ElevatedButton(
                              onPressed: () => {
                                  if(_validateName.currentState!.validate() && _validateTime.currentState!.validate())
                                  {
//-------------------------------------------------Values are fine, Moving Forward--------------------------------------------//
                                      timeChosen = int.parse(time_control.text),
                                      colorChosen = getColorSerial(dropdownValue!),
                                      
                                      if(widget.gameState == 1)
                                      {
//--------------------------------------------------Game 1 Forward-------------------------------------------------------------//
                                        BLE_Connection().write([1,timeChosen,colorChosen,3]),
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CountDown(nextScreen: Game1Timer(homescreen: widget.homescreen,time: timeChosen, color: colorChosen,
                                                                                                                            name: name_control.text,))),)
                                      }
                                      else
                                      {
//-------------------------------------------------Game 5 Forward-----------------------------------------------------------//
                                          BLE_Connection().write([5,5000,0,3]), // sending default values
                                           Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => TrainingLoading(nextScreen: CountDown(nextScreen: Game1Timer(homescreen: widget.homescreen,time: timeChosen, color: colorChosen, name: name_control.text,)), 
                                                                                                                            homeScreen: widget.homescreen, color: colorChosen, time: timeChosen,)))
                                      }
                                  }
                              }, 
                            
                              child: buttonTextDisplay(Text("Start",
                                        style: Theme.of(context).textTheme.displayMedium)),
                              )),
                          
                          const Spacer()
                          ],
                        ),
                        const Spacer(),
                    ],
                  ),
                ),
              )
        ]),
       )
      );
  }
}

//----------------------------------------------------------------------------------------------------------//
//----------------------------------------------Game Timer--------------------------------------------------//
//----------------------------------------------------------------------------------------------------------//

class Game1Timer extends StatefulWidget
{
  final Widget homescreen;
  int time;
  int color;
  final String name;
  Game1Timer({super.key, required this.homescreen, required this.time, required this.color, required this.name});

  bool isPaused = false; // at the start, the game is running
  String title = "Game Is On";

// if the game is ended/finished, 'waiting' disables pushing buttons
  bool waiting = false;

  @override
  State<Game1Timer> createState() => _Game1TimerState();
}

class _Game1TimerState extends State<Game1Timer> {
  late Timer timer;
  int current_time = 0;

//--------------------------------------------------Activate Timer-------------------------------------------------//
  void setCountDown() 
  {
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) async{
        if(current_time == 0)
        {
          stopBackgroundMusic(gameMusicPlayer);
          playBackgroundMusic(bgMusicPlayer);
          timer.cancel();
          setState(() {
            widget.waiting = true;
          });
          await Future.delayed(const Duration(seconds: 4));
          if(context.mounted)
          {
            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Game1_Stats(actual_time: widget.time,homescreen: widget.homescreen,name: widget.name,)));
          }

        }
        else
        {
          if(!widget.isPaused)    // not paused, then move forward
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
//----------------------------------Current Time Title----------------------------------------//
            Text(widget.title,
              style: Theme.of(context).textTheme.titleLarge,),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Time: $current_time",
                style: Theme.of(context).textTheme.bodyMedium),
            ),
            const Spacer(),
//------------------------------------------------------Finish Button--------------------------//
              ElevatedButton(
                onPressed: (!widget.waiting)
                    ? () async {
                  // Call stopBackgroundMusic when the button is pressed
                  stopBackgroundMusic(gameMusicPlayer);
                  playBackgroundMusic(bgMusicPlayer);

                  actualTime = widget.time - current_time;
                  timer.cancel();

                  setState(() {
                    widget.waiting = true;
                  });
                  BLE_Connection().write([8, 1, 1, 1]);
                  await Future.delayed(const Duration(seconds: 4));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Game1_Stats(
                        actual_time: actualTime,
                        homescreen: widget.homescreen,
                        name: widget.name,
                      ),
                    ),
                  );
                }
                    : null,
                child: buttonTextDisplay(
                  Text(
                    "Finish",
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ),
              ),

//---------------------------------------------------Pause Button------------------------------------------//
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                onPressed: !(widget.waiting) ? () => {
                      widget.isPaused = !widget.isPaused,
                      widget.isPaused ? BLE_Connection().write([6]) : BLE_Connection().write([1]),
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

class Game1_Stats extends StatelessWidget
{
  final Widget homescreen;
  final int actual_time;
  final String name;

  const Game1_Stats({super.key, required this.actual_time, required this.homescreen, required this.name});

  @override
  Widget build(BuildContext context) {
    //-----------------------------------------Listen for Disconnection------------------------------------------//
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(ConnectPage(homescreen: homescreen), context);
      asyncAlertESPNNow( ConnectPage(homescreen: homescreen), context);
    });
//----------------------------------------------------------------------------------------------------------//
//---------------------------------------------Collecting Statistics Data---------------------------------------//
    int totalTime = actual_time;
    int clicks = BLE_Connection().read_value[0];
    double avgClicks = (clicks.toDouble())/totalTime;
    String avgRounded = avgClicks.toStringAsFixed(5);
    return Scaffold(body: backgroundGradient(
         Column(children: [
          const Spacer(),
//--------------------------------------Title--------------------------------------------//
              Text("Great Job, $name!", style: Theme.of(context).textTheme.titleMedium,),
              const Spacer(),
              Row(children: [
                const Spacer(),
//------------------------------------Time Past------------------------------------------//
                displayText(
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, size: 45,),
                      Text("$actual_time seconds",style: Theme.of(context).textTheme.bodyMedium,)
                  ],),0
                ),
                const Spacer(),
//----------------------------------Click Number-----------------------------------------//
                displayText(
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Number of clicks:",style: Theme.of(context).textTheme.titleSmall,textAlign: TextAlign.center,),
                      Text("$clicks",style: Theme.of(context).textTheme.bodyMedium,)
                  ],),0
                ),
                const Spacer(),
              ],),
              const Spacer(),
//-------------------------------Average Clicks Per Second--------------------------------//
              displayText(
                 Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                      Text("Clicks per second:",style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center,),
                      Text(avgRounded,style: Theme.of(context).textTheme.bodyMedium,)
                  ],),0
              ),
              const Spacer(),
//-------------------------------Return to MyHomePage----------------------------------------//
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
                                style: Theme.of(context).textTheme.displayMedium,)),
                )),
                const Spacer(),
         ],)
      ),);
  }
}