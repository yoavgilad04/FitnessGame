

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';


//---------------------Explainations for Each Game for Floating Window---------------------------//
const String game1_name = "Work On Your Fitness";
const String game1_title = "Fitness Game - Work On Your Fitness!";
const List<String> exp1 = [
'''In this game, you will work on your fitness. The buttons should be spread around the room uniformly, preferably in the form of a square at equal distances.\n''',
'''Number of players:''',
" 1\n",
"Time:",
" 0-120 seconds\n",
"Game rules\n",
'''Fill in the relevant fields, and press a button whose light turns on according to the selected color. Click as fast as possible in the selected time range'''];
var text1 = RichText(
  text: TextSpan(
    style: textStyle.bodySmall!.copyWith(fontWeight: FontWeight.bold, height: 2),
    children: [
      TextSpan(text: exp1[0]),
      TextSpan(text: exp1[1], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp1[2]),
      TextSpan(text: exp1[3], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp1[4]),
      TextSpan(text: exp1[5], 
          style: textStyle.titleSmall!.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 2
          )),
      TextSpan(text: exp1[6])
    ]

  ));

 const String game2_name = "Work On Your Focus";
 const String game2_title = "Focus Game - Work On Your Concentration!";
 const List<String> exp2 = ['''This game will improve your concentration and reaction speed. It is recommended to press the buttons together and play on a comfortable surface\n''',
"Number of players:", " 1\n",
"Time:", " 0-120 seconds\n",
"Game Rules :\n",
'''The player will choose a single color on which the player will have to click. During the passing time, several colors will light up and the player must click only on the color he chose.'''];
var text2 = RichText(
  text: TextSpan(
    style: textStyle.bodySmall!.copyWith(height: 2),
    children: [
      TextSpan(text: exp2[0]),
      TextSpan(text: exp2[1], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp2[2]),
      TextSpan(text: exp2[3], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp2[4]),
      TextSpan(text: exp2[5], 
          style: textStyle.titleSmall!.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 2
          )),
      TextSpan(text: exp2[6])
    ]
  ));

  const String game3_name = "Multi-Player Fitness";
  const String game3_title = "Multi-Player Fitness";
  const List<String> exp3 = ['''In this game, you will compete against each other simultaneously, to decide once and for all who is faster.\n''',
  "Number of players:", " 2\n",
  "Time:", " 0-120 seconds\n",
  "Game Rules :\n",
  '''Each player will choose a color.Then, 2 lights will show up, one per each color.Each one should click only his/her color.'''
 ];

 var text3 = RichText(
  text: TextSpan(
    style: textStyle.bodySmall!.copyWith(height: 2),
    children: [
      TextSpan(text: exp3[0]),
      TextSpan(text: exp3[1], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp3[2]),
      TextSpan(text: exp3[3], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp3[4]),
      TextSpan(text: exp3[5], 
          style: textStyle.titleSmall!.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 2
          )),
      TextSpan(text: exp3[6])
    ]
  ));
AudioPlayer bgMusicPlayer = AudioPlayer(); // Background music player
AudioPlayer gameMusicPlayer = AudioPlayer(); // Game music player
AudioPlayer countdownPlayer = AudioPlayer();
bool isMute = false;


void playBackgroundMusic(AudioPlayer player) async {
  if (isMute == true)
    return;
  await player.stop(); // Stop any existing music before playing
  await player.setReleaseMode(ReleaseMode.loop); // Ensure looping

  // Choose the correct music file based on the player
  String musicFile;
  if (player == bgMusicPlayer) {
    musicFile = 'background_music.mp3';
  } else if (player == gameMusicPlayer) {
    musicFile = 'game_music.mp3';
  } else {
    musicFile = 'countdown.mp3';
  }


  // Ensure looping only for background and game music
  if (musicFile != 'countdown.mp3') {
    await player.play(AssetSource(musicFile));
    player.setReleaseMode(ReleaseMode.loop); // Enable looping
  } else {
    player.play(AssetSource(musicFile));
    player.setReleaseMode(ReleaseMode.stop); // Play only once
  }
}

void stopBackgroundMusic(AudioPlayer player) async {
  if (isMute == true)
    return;
  await player.stop(); // Stop the specified music player
}


const String game4_name = "Competition";
 const String game4_title = "Competition!";
 const List<String> exp4 = ['''In this game, each player will seperately, aiming for the best score.\n''',
 "Number of players:"," 2\n",
 "Time:", " 0-120 seconds\n",
 "Game Rules :\n",
 "This game is the same as the fitness game, but it will be held in 2 phases. Each player will play seperately, with 3 seconds between each one" 
];

var text4 = RichText(
  text: TextSpan(
    style: textStyle.bodySmall!.copyWith(height: 2),
    children: [
      TextSpan(text: exp4[0]),
      TextSpan(text: exp4[1], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp4[2]),
      TextSpan(text: exp4[3], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp4[4]),
      TextSpan(text: exp4[5], 
          style: textStyle.titleSmall!.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 2
          )),
      TextSpan(text: exp4[6])
    ]
  ));

const String game5_name = "Training";
 const String game5_title = "Training!";
 const List<String> exp5 = ['''In this game, You are in control\n''',
 "Number of players:"," 1\n",
 "Time:", " 0-120 seconds\n",
 "Game Rules :\n",
 "First, you will be asked to click the buttons in any order.Then, the buttons will light up at the order as you chose, so you need to click on it as fast as you can." 
];

var text5 = RichText(
  text: TextSpan(
    style: textStyle.bodySmall!.copyWith(height: 2),
    children: [
      TextSpan(text: exp5[0]),
      TextSpan(text: exp5[1], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp5[2]),
      TextSpan(text: exp5[3], 
          style: const TextStyle(decoration: TextDecoration.underline,
                                decorationThickness: 2)),
      TextSpan(text: exp5[4]),
      TextSpan(text: exp5[5], 
          style: textStyle.titleSmall!.copyWith(
            decoration: TextDecoration.underline,
            decorationThickness: 2
          )),
      TextSpan(text: exp5[6])
    ]
  ));


 //----------------------BLE Device Name--------------------------//
 
 var device_name = "ESP32";

 //----------------------Connection Instructions--------------------------//
String connectTitle = "Before connecting, please make sure:";

const String connectExp = '''1.Activate your Bluetooth and GPS on your phone.
2.Turn on all the buttons.
3.Put the buttons close to each other.
4.Hold your phone close to the blue button''';


//-----------------------FlexThemeData Styling----------------------------//

const FlexScheme flexScheme = FlexScheme.materialHc;
const int usedColors = 6;


const TextTheme textStyle = TextTheme(
  titleLarge: TextStyle(fontSize: 60,
                        fontFamily: 'PlayfairDisplay',),
  titleMedium: TextStyle(fontSize: 45,
                        fontFamily: 'PlayfairDisplay'),
  titleSmall: TextStyle(fontSize: 30,
                        fontFamily: 'PlayfairDisplay'),

  bodyMedium: TextStyle(fontSize: 25,
                        fontFamily: 'OpenSans'),
  bodySmall: TextStyle(fontSize: 15,
                      fontFamily: 'OpenSans'),

  displayLarge: TextStyle(fontSize: 45,
                          fontFamily: 'AnekMalayalam'),
  displayMedium: TextStyle(fontSize: 35,
                          fontFamily: 'AnekMalayalam'),
  displaySmall: TextStyle(fontSize: 15,
                          fontFamily: 'AnekMalayalam')
);


var darkTheme =   FlexThemeData.dark(
  scheme: flexScheme,
  usedColors: 6,
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
  blendLevel: 10,
  appBarStyle: FlexAppBarStyle.background,
  bottomAppBarElevation: 2.0,
  textTheme: textStyle,
  darkIsTrueBlack: false,
  subThemesData: const FlexSubThemesData(
    blendTextTheme: true,
    useTextTheme: true,
    // useM2StyleDividerInM3: true,
    thickBorderWidth: 2.0,
    elevatedButtonRadius: 40.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimary,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    outlinedButtonRadius: 2.0,
    inputDecoratorSchemeColor: SchemeColor.primary,
    // inputDecoratorBackgroundAlpha: 48,
    inputDecoratorRadius: 19.0,
    inputDecoratorBorderWidth: 3.5,
    // inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    tooltipRadius: 19,
    tooltipSchemeColor: SchemeColor.secondaryContainer,
    // drawerElevation: 1.0,
    // drawerWidth: 290.0,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondary,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondary,
    bottomNavigationBarMutedUnselectedIcon: false,
    navigationBarSelectedLabelSchemeColor: SchemeColor.onSecondaryContainer,
    navigationBarSelectedIconSchemeColor: SchemeColor.onSecondaryContainer,
    navigationBarIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationBarIndicatorOpacity: 1.00,
    navigationBarElevation: 1.0,
    navigationBarHeight: 72.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.onSecondaryContainer,
    navigationRailSelectedIconSchemeColor: SchemeColor.onSecondaryContainer,
    navigationRailIndicatorSchemeColor: SchemeColor.secondaryContainer,
    navigationRailIndicatorOpacity: 1.00,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
);

//-------------------------DropDown values-------------------------------//
var colorstrings = <String>['Random', 'Blue','Orange','Purple','Brown','Pink',"Cyan","White"];
var colorstrings2 = <String>['Blue','Orange','Purple','Brown','Pink',"Cyan","White"];
var rainbowColors = <Color>[Colors.blue,Colors.red,Colors.green,Colors.yellow,Colors.purple];

double? fieldWidth = 290;
//-----------------------Audio Player-------------------------//
final player = AudioPlayer();

//--------------------------Background for statistics--------------------------//

List<List<Color>> colorsBackground = [const [Color.fromARGB(255, 98, 197, 230),
                                        Color.fromARGB(255, 30, 144, 255),
                                        Color.fromARGB(255, 0, 0, 205),
                                        Color.fromARGB(255, 0, 0, 84),],
                                       
                                      const [Color.fromARGB(255, 0, 0, 205), 
                                        Color.fromARGB(255, 50, 205, 50),
                                        Color.fromARGB(255, 34, 139, 34),
                                        Color.fromARGB(255, 0, 201, 87)],
                                        
                                      const[Color.fromARGB(255, 255, 0, 0),
                                        Color.fromARGB(255, 220, 20, 60),
                                        Color.fromARGB(255, 178, 34, 34),
                                        Color.fromARGB(255, 205, 92, 92)],
                                        
                                      const [Color.fromARGB(255, 255, 215, 0),
                                        Color.fromARGB(255, 218, 165, 32),
                                        Color.fromARGB(255, 255, 140, 0),
                                        Color.fromARGB(255, 255, 165, 0),
                                        Color.fromARGB(255, 255, 127, 80)],
                                        
                                      const  [Color.fromARGB(255, 211, 211, 211),
                                        Color.fromARGB(255, 192, 192, 192),
                                        Color.fromARGB(255, 105, 105, 105),
                                        Color.fromARGB(255, 112, 128, 144),
                                        Color.fromARGB(255, 47, 79, 79)]];
