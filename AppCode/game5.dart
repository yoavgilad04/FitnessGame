import 'dart:async';

import 'package:fitnessgame_app/BLE.dart';
import 'package:fitnessgame_app/countdown.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


import 'package:fitnessgame_app/constants.dart';
import 'package:fitnessgame_app/functions.dart';

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
    return Scaffold(body: backgroundGradient(
      Center(
        child: Column(children: [
                const Spacer(),
                Text(widget.playing ? "Your Pattern is Loaded" : "Load Your Pattern", 
                    style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
                const Spacer(),
                ElevatedButton(
                onPressed:  !widget.waiting ?() async => {
                  if(widget.playing)
                  {
                    setState(() => {
                      widget.waiting = true,
                    },),
                    BLE_Connection().write([1,widget.time,widget.color,3]),
                    Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => widget.nextScreen)),
                  }
                  else
                  {
                    BLE_Connection().write([8,1,1,1]),
                    setState(() => {
                      widget.playing = true,
                    },)
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