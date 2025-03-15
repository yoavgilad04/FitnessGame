import 'dart:async';

import 'BLE.dart';
import 'package:flutter/material.dart';
import 'functions.dart';
import 'package:provider/provider.dart';

import 'Setting.dart';

class TrainingLoading extends StatefulWidget
{
  final Widget homeScreen;
  final Widget nextScreen;
  final int color;
  final int time;
  TrainingLoading({super.key, required this.homeScreen, required this.nextScreen, required this.color, required this.time});
  bool playing = false;
  bool waiting = false; 

  @override
  State<TrainingLoading> createState() => _TrainingLoadingState();
}

class _TrainingLoadingState extends State<TrainingLoading> {
  @override
  Widget build(BuildContext context) {
    //-----------------------------------------Listen for Disconnection------------------------------------------//
    var appState = context.watch<BLE_Connection>();
    Future.delayed(Duration.zero,() {
      asyncAlertBluetooth(ConnectPage(homescreen: widget.homeScreen), context);
      asyncAlertESPNNow( ConnectPage(homescreen: widget.homeScreen), context);
    });
//----------------------------------------------------------------------------------------------------------//
    return Scaffold(body: backgroundGradient(
      Center(
        child: Column(children: [
                const Spacer(),
//-------------------------------------- Title ----------------------------------------//
                Text(widget.playing ? "Your Pattern is Loaded" : "Load Your Pattern", 
                    style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
                const Spacer(),
                ElevatedButton(
                onPressed:  !widget.waiting ?() => {
                  if(widget.playing)
                  {
//-------------------------------------Start Playing------------------------------------//
                    setState(() => widget.waiting = true,),
                    BLE_Connection().write([1,widget.time,widget.color,3]),
                    Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => widget.nextScreen)),
                  }
                  else
                  {
//----------------------------------Finish Uploading the Pattern-------------------------//
                    BLE_Connection().write([8,1,1,1]),
                    setState(() => widget.playing = true,)
                  }
                } : null, 
                child: buttonTextDisplay(Text(widget.playing ? "Play" : "Finish",
                  style: Theme.of(context).textTheme.displayMedium))
                ),
                const Spacer(),
        ]),
      )
    ));
  }
}