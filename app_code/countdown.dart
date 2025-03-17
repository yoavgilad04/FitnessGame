import 'dart:async';
import 'constants.dart';
import 'countdown.dart';
import 'functions.dart';
import 'package:flutter/material.dart';


//------------------------------------------------------------------------------------------------------------//
//-------------------------------------------CoundDown Page---------------------------------------------------//
//------------------------------------------------------------------------------------------------------------//

class CountDown extends StatefulWidget
{
  final Widget nextScreen;
  const CountDown({super.key, required this.nextScreen});

  @override
  State<CountDown> createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  late Timer timer;
  String title = "Ready?";
  int current_time = 0;

//-----------------------------------------------Activate Timer for 3 Seconds----------------------------------//
  void setCountDown()
  {
    playBackgroundMusic(countdownPlayer);
    Duration oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, 
    (Timer timer) async {
        if(current_time == 0)
        {
          timer.cancel();
          if(context.mounted)
          {
            playBackgroundMusic(gameMusicPlayer);
            Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => widget.nextScreen));
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
    current_time = 3;
    super.initState();
  }

//--------------------------------------------Change Title----------------------------------------//
  String chooseString()
  {
    String s;
    switch(current_time){
      case 1 : s = "Set...";break;
      case 0 : s = "Go!!!"; break;
      default : s = "Ready?"; break;
    }
    return s;
  }
  @override
  Widget build(BuildContext context) {
    bool finished = (current_time == 0);
    title = chooseString();
    return Scaffold(
      body: backgroundGradient(
         Center(
           child: Column(
            children: [
            const Spacer(),
//---------------------------------------------CountDown Title-------------------------------------------//
            Text(title,
              style: Theme.of(context).textTheme.titleLarge,),
//---------------------------------------------Seconds Left----------------------------------------------//
            (!finished) ? Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("$current_time",
                style: Theme.of(context).textTheme.titleLarge,)
            ) : const Padding(padding: EdgeInsets.all(8.0)),
            const Spacer(),
                 ]),
         ),
      ),
    );
  }
}